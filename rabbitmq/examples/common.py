"""Connection settings shared by the lab producer and worker."""
import os

import pika


def parameters():
    # The lab broker publishes only on loopback; see compose.yaml.
    url = os.environ.get("AMQP_URL", "amqp://app:app-lab-only@127.0.0.1:5672/jobs")
    return pika.URLParameters(url)
