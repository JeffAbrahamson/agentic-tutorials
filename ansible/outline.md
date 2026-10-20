# Capability outline

Read in order; allow about 2–3 hours including predictions and worked answers.
The optional final chapter is a bridge to future infrastructure work.

| Chapter | Learning outcome: what can I now judge? | Brief coverage |
| --- | --- | --- |
| 1. Predict the run | Trace controller, transport, module, state and per-host ordering; distinguish a convergent task from a script and a transaction. | Fundamentals without Linux basics. |
| 2. Prove the target | Resolve inventory identity, groups, connection variables, privilege and effective configuration before changing hosts. | Personal hosts to a 30–50 host fleet; wrong-target success. |
| 3. Configure one real service | Read a complete nginx play, explain validation, notification and second-run behaviour, and distinguish provisioning from deployment. | Non-Docker service; coherent disposable-host example. |
| 4. Trace data and reuse | Explain Jinja evaluation, facts, register/when, precedence, roles and ownership; decide when abstraction earns its cost. | Python bridge; environments, inherited conventions and maintainability. |
| 5. Establish evidence | Compare syntax, lint, check/diff, isolated execution, repetition, drift repair and external acceptance checks. | Review and verify an agent's work; offline local exercises. |
| 6. Control a fleet change | Predict batches, concurrency, handler timing and abort behaviour; design draining, verification and reboot policy. | Jellybooks scale and availability decisions. |
| 7. Diagnose partial completion | Reconstruct disk/process/host state; recognise lost handler notifications; recover without assuming rollback or replay. | Failure and recovery; practical SRE reasoning. |
| 8. Keep operations maintainable | Assess secrets, dependency versions, SSH/bootstrap, repository structure, tags and proposed generated changes. | Security, inherited systems and bounded agent collaboration. |
| 9. Share ownership with Terraform and containers (optional) | Draw a single-writer boundary and a handover contract; identify requirements before a pod migration. | Future Terraform/Docker/pods without an unrelated feature tour. |
| Worked answers and field reference | Test predictions independently, then inspect causal reasoning; use concise operational references later. | Offline review exercises, adequate evidence and weak-answer warning signs. |
| Example files, sources and verification | Reproduce the lab after the flight; see exact versions, primary sources and what was and was not executed. | Complete supporting context and honest verification limits. |

Verification and failure behaviour occur throughout. Each substantial chapter
includes a concrete prediction or review exercise and an agent question with
expected evidence and warning signs. The full example is preserved alongside the
PDF; the PDF includes enough configuration and reasoning to read independently.
