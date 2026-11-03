# Capability outline

Read in order; allow about 2–3 hours including exercises and worked answers.
Chapter 1 is a reading primer. Part 1 (chapters 2–4) is a shorter awareness tour;
part 2 (chapters 5–11) is the main subject. Chapter 10 on Kubernetes is an optional
branch.

| Chapter | Learning outcome: what can I now judge? | Brief coverage |
| --- | --- | --- |
| 1. Read Docker, Compose and secret tools | What can I now read? Say what each construct in a Dockerfile, Compose file, command output, SOPS file or OpenBao policy is, roughly what it does, and what to look up. | Narrow current use; notation for every later chapter. |
| 2. What an image and a container really are | Predict what an image carries (layers, configuration, history) and what `inspect` reveals about a container; explain why deletion in a later layer hides nothing. | Narrow current use; mechanics behind secret leaks. |
| 3. Building beyond `docker build .` | Review a Dockerfile for multi-stage structure, cache mounts, build secrets, checks and attestations; know which features exist and when they pay. | Awareness of further possibilities. |
| 4. Running beyond `docker run` | Read a Compose project (interpolation, precedence, health-gated start, profiles, overrides); assess runtime hardening; use inspection commands as evidence. | Awareness; Compose on VMs. |
| 5. Why the repository model breaks | State the properties secrets need that code does not; explain why removing access never revokes a secret; name the secret lifecycle and "secret zero". | Git-like mental model. |
| 6. Secrets inside Docker | Identify every leak path in a build and a run; choose between build secrets, Compose file and environment secrets, Swarm secrets and the `_FILE` convention; predict rotation behaviour of bind mounts. | Current practice: ENV/ARG/-e, `.env`. Labs 1–2. |
| 7. Model one: encrypted files in git | Explain SOPS's envelope design, recipients and what removal does not undo; compare ansible-vault and git-crypt. | The git-like model done properly. Lab 3. |
| 8. Model two: a secret service | Explain authentication, policy, leases, dynamic credentials, audit and agents; weigh OpenBao, Vault, cloud managers and SaaS; recognise the operational cost. | Central models; hosted versus self-hosted. Lab 4. |
| 9. Delivery, identity and comparison | Separate storage, delivery and identity decisions; compare models on revocation, audit, rotation, availability and bootstrap; know where identity-based access removes secrets entirely. | Where the models differ; strengths and weaknesses. |
| 10. Kubernetes later (optional) | Predict Kubernetes Secret exposure; choose between ESO, Sealed Secrets, CSI and injectors so that today's choice carries forward. | Kubernetes in about a year. |
| 11. Choosing and migrating | Apply decision criteria to stated constraints; plan a staged migration from repository secrets; write acceptance criteria; handle a leak and a failed rotation with evidence. | Choose and implement the eventual solution. |
| Worked answers, reference, labs, sources and verification | Check reasoning; reproduce the labs; see versions, sources and what actually ran. | Honest verification limits. |

Verification and failure behaviour occur throughout. Each substantial
chapter after the primer has an exercise and questions to ask an agent, with the evidence a
good answer contains and warning signs in a weak one.
