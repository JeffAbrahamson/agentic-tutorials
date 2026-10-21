"""Process jobs from jobs.work with manual acknowledgements.

The "work" is recording the job in a SQLite ledger keyed by message_id, so a
redelivered job is detected rather than applied twice. Failure options make
the delivery behaviour observable; the worker exits after --idle seconds
without a delivery.
"""
import argparse
import json
import os
import sqlite3
import sys
import time

import pika

from common import parameters


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--ledger", default="ledger.sqlite")
    parser.add_argument("--prefetch", type=int, default=10)
    parser.add_argument("--work-seconds", type=float, default=0.1)
    parser.add_argument("--idle", type=float, default=3.0)
    parser.add_argument("--poison", type=int, action="append", default=[],
                        help="job that fails permanently: reject without requeue")
    parser.add_argument("--flaky", type=int, action="append", default=[],
                        help="job that fails transiently: requeue it for retry")
    parser.add_argument("--retry-verb", choices=["reject", "nack"], default="reject",
                        help="how to requeue a flaky job; nack never reaches the "
                             "delivery limit (chapter 4)")
    parser.add_argument("--crash-before-ack", type=int,
                        help="exit abruptly after recording this job, before acking it")
    args = parser.parse_args()
    sys.stdout.reconfigure(line_buffering=True)  # keep output across os._exit

    ledger = sqlite3.connect(args.ledger, isolation_level=None)
    ledger.execute("CREATE TABLE IF NOT EXISTS done "
                   "(message_id TEXT PRIMARY KEY, pid INTEGER, at REAL)")

    with pika.BlockingConnection(parameters()) as connection:
        channel = connection.channel()
        channel.basic_qos(prefetch_count=args.prefetch)
        deliveries = channel.consume("jobs.work", inactivity_timeout=args.idle)
        for method, properties, body in deliveries:
            if method is None:  # idle for args.idle seconds
                break
            job = json.loads(body)["job"]
            count = (properties.headers or {}).get("x-delivery-count", 0)
            tag = f"{properties.message_id} redelivered={method.redelivered} count={count}"
            if job in args.poison:
                print(f"{tag} rejected (poison)")
                channel.basic_reject(method.delivery_tag, requeue=False)
                continue
            if job in args.flaky:
                print(f"{tag} requeued by {args.retry_verb}")
                if args.retry_verb == "reject":
                    channel.basic_reject(method.delivery_tag, requeue=True)
                else:
                    channel.basic_nack(method.delivery_tag, requeue=True)
                continue
            time.sleep(args.work_seconds)
            inserted = ledger.execute(
                "INSERT OR IGNORE INTO done VALUES (?, ?, ?)",
                (properties.message_id, os.getpid(), time.time())).rowcount
            print(f"{tag} {'recorded' if inserted else 'duplicate ignored'}")
            if job == args.crash_before_ack:
                print(f"{tag} crashing before ack")
                os._exit(1)
            channel.basic_ack(method.delivery_tag)
        channel.cancel()


if __name__ == "__main__":
    main()
