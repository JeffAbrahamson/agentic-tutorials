#!/bin/sh
# Replay the chapter 5 cluster experiments against a fresh three-node cluster.
# Destroys and recreates the rabbitmq-cluster-lab Compose project and volumes.
set -u
cd "$(dirname "$0")"
PY=${PY:-../.venv/bin/python}
RABBIT1=amqp://app:app-lab-only@127.0.0.1:5673/jobs

members() {
    docker compose exec -T "$1" rabbitmq-queues -q quorum_status jobs.work \
        --vhost jobs --formatter json |
        python3 -c 'import json, sys
for r in json.load(sys.stdin): print("   ", r["Node Name"], r["Raft State"])'
}
step() { printf '\n## %s\n' "$*"; }

docker compose down -v >/dev/null 2>&1
docker compose up -d --wait >/dev/null 2>&1 || { echo "cluster did not start"; exit 1; }

step "1. members of jobs.work after definitions were imported at boot"
members rabbit1

step "2. grow every jobs queue onto every node"
for node in rabbit1 rabbit2 rabbit3; do
    docker compose exec -T rabbit1 rabbitmq-queues -q grow "rabbit@$node" all \
        --vhost-pattern '^jobs$' --queue-pattern '.*' >/dev/null
done
members rabbit1

step "3. stop rabbit3, publish jobs 100-102 through rabbit1"
docker compose stop rabbit3 >/dev/null 2>&1
AMQP_URL=$RABBIT1 timeout 30 $PY ../producer.py 100 3; echo "exit=$?"
members rabbit1

step "4. may rabbit2 be stopped now?"
docker compose exec -T rabbit2 rabbitmq-queues -q check_if_node_is_quorum_critical
echo "exit=$?"

step "5. stop rabbit2 as well, publish job 103 through rabbit1 (30 s limit)"
docker compose stop rabbit2 >/dev/null 2>&1
AMQP_URL=$RABBIT1 timeout 30 $PY ../producer.py 103 1; echo "exit=$?"

step "6. restart rabbit2 and rabbit3, count messages"
docker compose start rabbit2 rabbit3 >/dev/null 2>&1
docker compose up -d --wait >/dev/null 2>&1
sleep 6
members rabbit1
docker compose exec -T rabbit1 rabbitmqctl -q list_queues -p jobs name messages_ready
