# Capability outline

Read in order; allow about 2–3 hours including predictions and worked answers.
Chapter 8 is an optional branch for C++ integration.

| Chapter | Learning outcome: what can I now judge? | Brief coverage |
| --- | --- | --- |
| 1. From sockets to a broker | Predict a message's route through exchange, binding and queue; explain which state the broker owns, unlike ZeroMQ; recognise silently dropped unroutable messages. | ZeroMQ bridge; light prior RabbitMQ use. |
| 2. Hand-offs you can trust | Trace responsibility for a message through publisher confirms, consumer acknowledgements, prefetch and redelivery; explain why at-least-once demands idempotency. | Build new messaging; review agent-written clients. |
| 3. The job pipeline | Read a complete producer, worker and topology; predict the outcome of killing a worker mid-job and of rerunning the producer. | Coherent runnable Python example. |
| 4. Choosing queues and failure paths | Choose classic, quorum or stream; design retry and dead-lettering; decide who owns topology and why policies beat hard-coded arguments. | Retained design decisions; growth of the example. |
| 5. Running a cluster | Predict quorum-queue availability under node loss; explain alarms and flow control; plan a rolling upgrade. | Operate a cluster. |
| 6. Evidence before edits | Map symptoms (backlog, blocked publishers, loss, duplicates, poison loops, precondition errors) to distinguishing evidence; judge an agent's diagnosis. | AI-assisted debugging of incidents. |
| 7. Keeping it safe and maintainable | Assess users, vhosts, permissions, TLS, definitions and secrets; review a proposed generated change. | Security and inherited conventions. |
| 8. Integrating C++ clients (optional) | Define a cross-language message contract; review event-loop ack/confirm handling and channel threading in C++. | C++ client integration. |
| Worked answers and field reference | Check predictions against causal reasoning; quick operational reference. | Exercises with reasoning. |
| Example files, sources and verification | Reproduce the lab; see versions, sources and what actually ran. | Honest verification limits. |

Verification and failure behaviour occur throughout. Each substantial chapter
has a prediction or review exercise and an agent question with expected
evidence and warning signs.
