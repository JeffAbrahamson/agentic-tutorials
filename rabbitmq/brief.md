# Learner brief

**Learner.** Jeff, with the baseline background assumed by `SKILL.md`. He has used RabbitMQ lightly: publishing and consuming, but not designing topology or operating a broker. His main messaging background is ZeroMQ, used in a fairly simple way. ZeroMQ is therefore the principal bridge, with explicit attention to where a brokerless socket model stops predicting RabbitMQ's behaviour. He is reasonably comfortable with Docker and Python.

**Intended work.** Build new messaging between services, operate a RabbitMQ cluster, and diagnose incidents. Python is the starting point; C++ clients will also be integrated. Infrastructure and debugging will both be done with AI assistance, so the tutorial teaches him to direct, question and check an agent's design and investigation, not to memorise commands.

**Desired outcomes.** Predict where a published message goes and when it is safe; choose delivery guarantees, queue types and topology; review agent-written producers, consumers and broker configuration; judge cluster behaviour under node loss and upgrade; connect incident symptoms to evidence, and recognise when an agent's diagnosis is unsupported.

**Retained decisions.** Inferred from the collaboration role: delivery guarantees and idempotency requirements, queue types and replication, topology ownership (application versus definitions), retry and dead-letter policy, message contracts shared with C++ clients, cluster size and upgrade strategy, access and secrets policy, alerting thresholds, and incident acceptance criteria. Client boilerplate, declarations, Compose files and command invocation can be delegated.

**Reading.** As for the Ansible tutorial: a substantial 2–3 hour tutorial read offline on a tablet, with prediction and review exercises and separately placed worked answers. No terminal is needed to learn; runnable examples are for later.

**Agreed deliverable.** A tablet-friendly PDF built like the Ansible tutorial: Markdown source rendered locally with Pandoc and XeLaTeX, Latin Modern Roman 12 pt body and Latin Modern Mono code, 160 × 230 mm pages. Markdown suits code-heavy material and easy revision; the content has little mathematical notation, so native LaTeX offers no material advantage.

**Target.** RabbitMQ 4.4.0 (official Docker image `rabbitmq:4.4.0-management`, released 19–20 October 2026; 4.3 is the other community-supported series), Python client pika 1.4.4 on Python 3.12, local Docker Compose (single node and three-node cluster). C++ clients are discussed, not executed. AMQP 0-9-1 is the protocol taught; AMQP 1.0 and streams are noted where they change a decision.

**Research.** 21 October 2026. Primary sources: rabbitmq.com documentation, RabbitMQ release notes, client library documentation and repositories. Distinguish documented guarantees from conventions and recommendations.

**Scope.** Broker model, routing, confirms and acknowledgements, prefetch, queue types, dead-lettering and retry, topology ownership, clustering and quorum, alarms and flow control, upgrades, observability, diagnosis, security basics, and C++ integration concerns. Outside scope: Kubernetes operator, federation and shovel beyond a mention, plugin development, exhaustive management API coverage, and Kafka migration.

**Example.** A small job pipeline: a Python producer submits work, Python workers process it, failures are retried and dead-lettered. It is a teaching fixture, not a proposed Jellybooks architecture. It runs against disposable local containers only.

**Open details.** Actual message volumes, latency targets, host platform for production brokers, which C++ library the existing clients use, and whether any RabbitMQ deployment already exists. These do not block the tutorial; production adoption must revisit them.
