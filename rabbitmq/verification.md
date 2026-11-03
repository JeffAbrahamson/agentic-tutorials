# Verification record

Date: 21 October 2026. Target and executed versions: RabbitMQ 4.4.0 from the official image `rabbitmq:4.4.0-management` (Erlang 29.1.2), pika 1.4.4, Python 3.12.3, Docker 27.2.0 with Compose v2, on Linux. Sources are linked beside claims in the tutorial: rabbitmq.com documentation, release notes for 4.0.1, 4.3.0 and 4.4.0, pika's documentation and source, the rabbitmq-c and AMQP-CPP repositories, and PyPI and Docker Hub metadata.

## Single-node lab (`examples/lab.sh`)

Run in full from a fresh Compose project with the final definitions. All ports were bound to `127.0.0.1`.

| Step | Observation |
| --- | --- |
| Broker start | Definitions imported at boot: vhost `jobs`, users, exchanges, two quorum queues, bindings and the `work-failures` and `dead-letters` policies, confirmed with `list_queues` and `list_policies` |
| 1. Publish jobs 1–5 | All confirmed; exit 0; `jobs.work` ready=5 |
| 2. Mistyped routing key with `mandatory` | `UnroutableError`; exit 2; queue unchanged |
| 3. Crash after recording job 3 | Jobs 1–3 recorded, 1–2 acked; exit 1; ready=3 |
| 4. Fresh worker | Job 3 `redelivered=True count=1 duplicate ignored`; jobs 4–5 `redelivered=True count=1 recorded` |
| 5. Producer rerun for jobs 1–5 | Five deliveries with `redelivered=False`, all ignored by the ledger |
| 6. Poison 21, flaky 22 retried with `basic.reject` | 21 rejected once; 22 delivered with counts 0–5, then dead-lettered; `jobs.dead` ready=2 |
| 7. Peek at dead letters | `job-21` reason `rejected`; `job-22` reason `delivery_limit`; three further peeks left `x-delivery-count` unchanged (1 and 6) |
| 8. Flaky 30 retried with `basic.nack`, 5 s bound | 842 deliveries (834 on a repeat run), `x-delivery-count` constant at 0 |

An unbounded run of the `nack` case delivered one message more than 20,000 times in under two minutes, with the count fixed at 0.

Quorum queue counters from `rabbitmqctl list_queues` read 0 immediately after three confirmed publishes and 3 after two seconds; a consumer count also persisted for a few seconds after a worker exited. `lab.sh` samples after a delay for this reason.

Exercise 4 was executed with both prefetch values; the worked answer reproduces the observed lines.

## Additional single-node checks

- **Memory alarm.** With `set_vm_memory_high_watermark 0.0001`: a confirm-mode publisher waited until killed by `timeout` after 25 s (exit 124); `list_connections user state` showed `app blocked`; a worker on another connection consumed normally; after the watermark was restored, the message from a killed publisher had been enqueued.
- **Alarm probes.** Under the alarm, `rabbitmq-diagnostics check_alarms` exited 69 and `alarms` listed the memory alarm. `check_local_alarms -q` printed "reported no local alarms" and exited 0; without `-q` it printed "This command is DEPRECATED and is a no-op". The same comparison on fresh `4.3.6-management` and `4.2.9-management` containers: 4.3.6 behaved like 4.4.0; 4.2.9 reported the alarm and exited 69. The rabbitmq-diagnostics man page read the same day does not mark the command deprecated.
- **Effective defaults** via `rabbitmqctl eval`: `consumer_timeout` 1800000, `max_message_size` 16777216, `heartbeat` 60, `vm_memory_high_watermark` 0.6, `disk_free_limit` 50000000, `quorum_cluster_size` 3.
- **Consumer timeout.** A quorum queue with `x-consumer-timeout` 5000 and an unacknowledging consumer: the broker cancelled the consumer at 5.0 s; the channel remained open; the message returned to ready.
- **Permissions and declarations.** `app` declaring `jobs.work`: `403 ACCESS_REFUSED`. `admin` redeclaring it as classic: `406 PRECONDITION_FAILED - inequivalent arg 'x-queue-type'`; with identical arguments: success. A transient non-exclusive classic queue: connection closed with `541 INTERNAL_ERROR` naming `transient_nonexcl_queues`.
- **Length limit with `reject-publish`**, `max-length` 1, six confirmed publishes: classic queue `ack, NACK×5`, one message stored; quorum queue `ack, ack, NACK×4`, two messages stored.
- **Erlang cookie race.** On a fresh volume, a root `rabbitmq-diagnostics` call made through `docker compose exec` created `/var/lib/rabbitmq/.erlang.cookie` owned by root with mode 0400, and the server then exited with `eacces` reading it. The image itself contains no cookie. Running the container as `999:999` removed the failure across subsequent fresh starts.
- **`RABBITMQ_ERLANG_COOKIE`** was honoured by a 4.4.0 node, which logged "Overriding Erlang cookie using the value set in the environment".

## Cluster lab (`examples/cluster/lab.sh`)

Run in full from a fresh Compose project, twice in total; the second run is quoted in the tutorial.

| Step | Observation |
| --- | --- |
| Cluster start | Three running disk nodes on RabbitMQ 4.4.0 |
| 1. Members after boot-time import | One member (rabbit2 on the first run, rabbit3 on the second) |
| 2. `rabbitmq-queues grow` per node | Three members, one leader |
| 3. rabbit3 stopped, publish 100–102 via rabbit1 | All confirmed; new leader on rabbit1 |
| 4. `check_if_node_is_quorum_critical` on rabbit2 | Named both queues and `rabbitmq_metadata`; exit 69 |
| 5. rabbit2 also stopped, publish 103 | No confirm; killed by `timeout` after 30 s (exit 124) |
| 6. Nodes restarted | Three members; `jobs.work` held 4 messages |

A separate instrumented publish to the minority node showed connection, channel opening and confirm mode completing within 0.1 s, followed by an indefinite wait for the confirm; that message was also present after the other nodes returned. `quorum_status --formatter csv` failed with an `ArgumentError` in 4.4.0, so the scripts use the JSON formatter.

## Document checks

`make -C rabbitmq` built the PDF without errors or missing-glyph warnings: 60 pages of 160 × 230 mm. A word bounding-box check found no text outside the horizontal body margins (6-point tolerance); the only text below the body is page numbers. All pages were rendered and inspected for layout, code wrapping, tables and headings.
Markdown code fences are balanced and the README's supporting-file links resolve. `producer.py` is reproduced in full and the worker loop verbatim. `git diff --check HEAD` passed.

## Reading primer, 3 November 2026

The parts of chapter 1 listed here ran against a disposable `rabbitmq:4.4.0-management` container, its ports on loopback only, with pika 1.4.4 on Python 3.14. The lab pins Python 3.12; nothing in the chapter depends on the difference. Observations:

- An `exclusive=True` declare with an empty name succeeded without `durable`. The hello programs printed the output shown, with the queue listed as classic and durable between them. Without `durable=True`, `queue_declare` was closed with `541 INTERNAL_ERROR` naming `transient_nonexcl_queues`.
- An empty queue name returned an `amq.gen-` name. Redeclaring `q1` with a different type gave the 406 shown. A `passive` declare of a missing queue and a publish to a missing exchange gave 404. A queue named `amq.mine` and a bad password gave 403.
- The publish with properties delivered `message_id`, `headers`, `delivery_mode` and `content_type` as set, through a topic binding on `orders.*.created`.
- `set_policy`, `list_policies` and `clear_policy` worked on the default vhost, and `list_queues` without `-p` reported that vhost. A consumer with prefetch 2 on 3 messages gave the counters shown. `list_connections` showed `running`.
- `--formatter=json`, `-q`, `check_running`, `quorum_status`, `rabbitmq-plugins list -e` and `rabbitmqadmin list queues` (version 2.35.0) ran. The plugin markers, listener ports, log format, file paths and `10-defaults.conf` were read from that container. The HTTP API answered at `/api/queues/%2F/q2`.

**Not run, and following the documentation source:** the 312, 320, 405 and 530 replies, a 406 from a bad ack, the `flow` and `blocking` connection states, `advanced.config`, the `.relative` and `.absolute` configuration families, the `RABBITMQ_` environment variables, `set_permissions`, `-n`, `amq.rabbitmq.reply-to`, `auto_delete`, `exclusive` queue removal, `x-message-ttl` and `x-expires`, the `-p jobs` form of `set_policy`, and the `ConnectionParameters` fragment, which pika accepted but did not use to connect. The same goes for `export_definitions`, `rabbitmq-upgrade` and the `#` wildcard. `basic_get` and `rabbitmqctl eval` did run. `www.rabbitmq.com/docs` refused automated requests on this date, so the `rabbitmq/rabbitmq-website` repository was read instead and the two newly cited pages were not fetched as rendered.

Exercise and answer links were followed in the PDF from each link annotation to the text at its destination: 9 links each way, all landing on the right heading. Chapter 1's pages were rendered and inspected; the bounding-box check under "Document checks" dates from 21 October and covers the rest.

## Limits

Not executed: the delayed-retry design sketch, throughput and prefetch tuning, TLS, upgrades between versions, true network partitions (nodes were stopped, not isolated), the `blocked_connection_timeout` parameter, AMQP 1.0 clients, and hosts other than Docker on Linux. The C++ code in chapter 9 was not compiled or run; library statements come from their READMEs and release metadata. Documentation URLs on rabbitmq.com are unversioned and were read on the date above. Nothing was run against a non-lab broker.
