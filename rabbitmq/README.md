# RabbitMQ: from sockets to a broker you can trust

The tutorial is [rabbitmq.pdf](rabbitmq.pdf): a 2–3 hour read, with prediction and review exercises and worked answers, covering routing, publisher confirms and consumer acknowledgements, queue types, retries and dead-lettering, topology ownership, clustering and node loss, alarms, upgrades, incident diagnosis, security, and an optional chapter on C++ clients.

The source is [tutorial.md](tutorial.md). Its scope and teaching assumptions are recorded in [brief.md](brief.md) and [outline.md](outline.md). The target is RabbitMQ 4.4.0 with Python 3.12 and pika 1.4.4; examples run against local Docker containers.

## Build the PDF

Required tools: GNU Make, Pandoc, XeLaTeX, and the Latin Modern Roman and Latin Modern Mono fonts. The TeX installation needs the packages used by Pandoc's default LaTeX template, plus `fvextra`, `microtype`, `ragged2e`, `etoolbox` and `needspace`. On Debian/Ubuntu, the usual packages are `make`, `pandoc`, `texlive-xetex`, `texlive-latex-extra`, `texlive-fonts-recommended` and `fonts-lmodern`. No network access is required once the toolchain is installed.

From the repository root:

```sh
make -C rabbitmq
```

This produces `rabbitmq/rabbitmq.pdf`, using the same 160 × 230 mm layout and fonts as the other tutorials. Temporary files live in ignored `.build/`. [pdf-header.tex](pdf-header.tex) supplies small typesetting adjustments, and [code-breaks.lua](code-breaks.lua) lets inline code break only at separators such as `/`, `.` and `_`, never mid-word.

## Examples

Requirements: Docker with Compose v2, Python 3.12, `curl`, and free loopback ports 5672 and 15672 (single node) or 5673–5675 and 15673 (cluster). Run from `rabbitmq/examples/`:

```sh
python3 -m venv .venv && .venv/bin/pip install -r requirements.txt
./lab.sh            # single-node experiments, chapters 2–4
cluster/lab.sh      # three-node experiments, chapter 5
```

Both scripts **destroy and recreate** their own Compose project (`rabbitmq-lab` or `rabbitmq-cluster-lab`) and its volumes. All ports are published on `127.0.0.1` only, and the credentials and Erlang cookie are lab-only values. Tear down afterwards with `docker compose down -v` in `examples/` and in `examples/cluster/`.

Supporting files:

- [Single-node Compose file](examples/compose.yaml), [broker configuration](examples/broker/rabbitmq.conf) and [definitions](examples/broker/definitions.json): users, vhost, exchanges, queues, bindings and policy.
- [Pinned client](examples/requirements.txt), [connection settings](examples/common.py), [producer](examples/producer.py) and [worker](examples/worker.py).
- [Single-node lab script](examples/lab.sh).
- [Cluster Compose file](examples/cluster/compose.yaml), [cluster configuration](examples/cluster/rabbitmq.conf) and [cluster lab script](examples/cluster/lab.sh).

[verification.md](verification.md) records what was executed and what remains untested. The C++ code in chapter 8 is an untested excerpt.
