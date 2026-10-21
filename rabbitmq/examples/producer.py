"""Submit jobs FIRST..FIRST+COUNT-1, waiting for a broker confirm for each.

Usage: python producer.py FIRST COUNT [ROUTING_KEY]
Exit status: 0 all confirmed, 2 unroutable, 3 nacked by the broker.
"""
import json
import sys

import pika
from pika.exceptions import NackError, UnroutableError

from common import parameters


def main():
    first, count = int(sys.argv[1]), int(sys.argv[2])
    routing_key = sys.argv[3] if len(sys.argv) > 3 else "work"
    with pika.BlockingConnection(parameters()) as connection:
        channel = connection.channel()
        channel.confirm_delivery()
        for n in range(first, first + count):
            message_id = f"job-{n}"
            properties = pika.BasicProperties(
                content_type="application/json",
                delivery_mode=pika.DeliveryMode.Persistent,
                message_id=message_id,
            )
            body = json.dumps({"job": n}).encode()
            try:
                # Blocks until the broker confirms or rejects this message.
                channel.basic_publish("jobs", routing_key, body, properties,
                                      mandatory=True)
            except UnroutableError:
                print(f"{message_id} unroutable: no queue bound for {routing_key!r}")
                return 2
            except NackError:
                print(f"{message_id} nacked: the broker did not take responsibility")
                return 3
            print(f"{message_id} confirmed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
