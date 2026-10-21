# Capability outline

Allow 2–3 hours including predictions and worked answers. The PDF is self-contained.

| Chapter | What can I now judge? | Brief coverage |
| --- | --- | --- |
| 1. Predict the engine | Distinguish configuration, state, real objects, provider reads and a dependency graph; explain why apply is not a transaction or a daemon. | First principles and SaltStack bridge. |
| 2. Read a small system | Trace types, references, variables, outputs and provider requirements in a complete local manifest example. | HCL literacy without syntax drills; Ansible handover. |
| 3. Review a plan | Identify the target, unknowns, replacements, saved-plan limitations and independent acceptance evidence. | Wrong-target success and reviewed agent changes. |
| 4. Preserve identity | Compare count and for_each, refactor with moved, and reason about replacement and lifecycle. | Long-lived fleets and bounded change. |
| 5. Own the state | Choose boundaries, backend and locking; separate environments and secrets; recover keys and state. | Personal versus organisation constraints. |
| 6. Grow deliberately | Recognise useful module interfaces, explicit dependencies, provider aliases and version controls. | Existing conventions, team ownership and reuse. |
| 7. Adopt an existing fleet | Inventory and import without accidental mutation; stage a long transition with single-writer field ownership. | Jellybooks and OpenTofu/Ansible/Salt boundaries. |
| 8. Establish evidence | Distinguish validation, assertions, provider execution and external tests; verify repeat runs and drift. | Agent review and verification limits. |
| 9. Recover partial completion | Reconstruct state/API evidence, triage locks and drift, and explain why reverting Git is not rollback. | Failure, recovery and practical SRE judgement. |
| 10. Choose an engine and a next step | Evaluate Terraform compatibility and safe engine migration; specify a bounded real project. | Optional advanced branch and production decisions. |
| Worked answers | Check predictions and design decisions against causal reasoning. | Offline review exercises, evidence and warning signs. |
| Field reference, lab guide and sources | Reproduce the local examples later; find artifacts, versioned sources and honest validation scope. | Tablet reading and reproducibility. |

Every chapter includes an outcome, a concrete review or prediction exercise, and a question to ask an agent with adequate evidence and warning signs. Advanced operational choices are bounded by the unspecified actual hosting environment rather than padded out as a cloud feature tour.
