#!/bin/sh
# Replay the single-node experiments from chapters 2-4 against a fresh broker.
# Destroys and recreates the rabbitmq-lab Compose project and its volume.
set -u
cd "$(dirname "$0")"
PY=${PY:-.venv/bin/python}

queues() {
    sleep 6   # quorum queue counters are refreshed periodically, not per message
    docker compose exec -T rabbit rabbitmqctl -q list_queues -p jobs \
        name messages_ready messages_unacknowledged consumers
}
step() { printf '\n## %s\n' "$*"; }

docker compose down -v >/dev/null 2>&1
docker compose up -d --wait >/dev/null 2>&1 || { echo "broker did not start"; exit 1; }
rm -f ledger.sqlite

step "1. publish jobs 1-5 with confirms"
$PY producer.py 1 5; echo "exit=$?"; queues

step "2. publish with a mistyped routing key"
$PY producer.py 6 1 wokr; echo "exit=$?"; queues

step "3. worker crashes after recording job 3, before acking it"
$PY worker.py --crash-before-ack 3; echo "exit=$?"; queues

step "4. a fresh worker drains the queue"
$PY worker.py; echo "exit=$?"; queues

step "5. the producer is rerun for jobs 1-5"
$PY producer.py 1 5 >/dev/null; $PY worker.py; queues

step "6. poison job 21 and flaky job 22, retried with basic.reject"
$PY producer.py 20 4 >/dev/null; $PY worker.py --poison 21 --flaky 22; queues

step "7. dead letters (peeked through the management API, then requeued)"
curl -s -u admin:admin-lab-only -H 'content-type: application/json' \
    -X POST http://127.0.0.1:15672/api/queues/jobs/jobs.dead/get \
    -d '{"count":10,"ackmode":"ack_requeue_true","encoding":"auto"}' |
    python3 -c 'import json, sys
for m in json.load(sys.stdin):
    h = m["properties"].get("headers", {})
    print(m["properties"]["message_id"], h.get("x-first-death-reason"),
          [(d["reason"], d["count"]) for d in h.get("x-death", [])])'

step "8. flaky job 30 retried with basic.nack, stopped after 5 s"
$PY producer.py 30 1 >/dev/null
timeout 5 $PY worker.py --flaky 30 --retry-verb nack > nack.log
echo "deliveries in 5 s: $(wc -l < nack.log)"; sort -u -k2,3 nack.log | cut -d' ' -f1-3
queues
