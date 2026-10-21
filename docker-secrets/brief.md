# Learner brief

**Learner.** Jeff, with the baseline background assumed by `SKILL.md`. He uses Docker regularly but within a narrow subset: build images, run containers, exec into them. Earlier tutorials in this repository cover Ansible, OpenTofu and RabbitMQ; the Jellybooks fleet of roughly 30–50 hosts comes from those briefs. His mental model of secrets is git-like (a private repository with restricted access is the source of truth), and he recognises that it does not scale.

**Current practice (stated).** Plaintext `.env` files kept outside git; secrets baked into images or passed with `ENV`, `ARG` or `-e`; and many secrets in private git repositories whose access is limited to a few people.

**Runtime.** Docker Compose on individual VMs or hosts, managed with Ansible. Kubernetes is planned but probably a year away. Hosted and self-hosted secret services are both acceptable candidates; no cloud provider is chosen.

**Desired outcomes.**
- Part 1, awareness: a short tour of what Docker offers beyond build, run and exec, chosen for usefulness and for the mechanics that matter to secrets (image layers and configuration, BuildKit, Compose, runtime hardening, inspection).
- Part 2, the main subject: understand the current models of secret management, how they differ, their strengths and weaknesses, and how to choose and implement an eventual solution. Be able to judge an agent's proposals and implementations in this area.

**Retained decisions.** Inferred from the collaboration role: threat model and who may read what; source of truth for secrets; storage model (encrypted files, central service, platform-native); delivery mechanism to Compose hosts and later Kubernetes; bootstrap ("secret zero") and recovery of root keys; rotation and revocation policy; audit requirements; hosted versus self-hosted; migration order and leak response. Dockerfile and Compose details, Ansible tasks, agent configuration and tool invocation can be delegated.

**Reading and format.** As for the earlier tutorials: a substantial 2–3 hour read offline on a tablet, with prediction, review and design exercises and separately placed worked answers. No terminal is needed to learn; runnable labs are for later. Format confirmed: tablet-friendly PDF built from Markdown with Pandoc and XeLaTeX, Latin Modern Roman 12 pt body, Latin Modern Mono code, 160 × 230 mm pages. Markdown suits code- and configuration-heavy material and easy revision; there is little mathematical notation.

**Target.** Docker Engine 29.9 (29.9.2 released 20 October 2026; labs executed on 29.9.1 in a disposable Docker-in-Docker daemon), Compose v5.6, Buildx 0.38, BuildKit 0.34, Dockerfile frontend 1.28. SOPS 3.13.3 with age 1.3.2; OpenBao 2.7.1; PostgreSQL 18 (official Alpine image) as the credential consumer. Kubernetes 1.37 is discussed, not executed. HashiCorp Vault 2.x, cloud secret managers and SaaS products are compared from documentation.

**Research.** 21 October 2026. Primary sources: docs.docker.com, the Compose specification and source, BuildKit source, Docker Official Image documentation and entrypoints, getsops.io, the age repository, openbao.org and its changelog, HashiCorp documentation and licence, Kubernetes documentation, vendor pricing pages, OWASP and NIST.

**Scope.** Part 1: image and container model, BuildKit features, Compose features, hardening and inspection. Part 2: why repository-based secrets fail, secret lifecycle and threat model, leak paths in Docker, Compose and Swarm secrets, encrypted-files-in-git (SOPS, ansible-vault, git-crypt), central secret services (OpenBao/Vault, cloud managers, SaaS), platform-native delivery (Kubernetes Secrets and operators), identity-based approaches, delivery patterns for Compose hosts, choosing and migrating, rotation and leak response. Outside scope: Swarm operations, Kubernetes implementation beyond decision-relevant behaviour, HSM and PKI design, production OpenBao deployment (HA, storage, unseal) beyond the decisions it forces.

**Example.** A small service with a PostgreSQL database and a client, used in four labs: leaks through a Docker build and run; Compose secrets and rotation; SOPS with age in a git repository; OpenBao issuing dynamic PostgreSQL credentials rendered by an agent. These are teaching fixtures with lab-only values, not a proposed Jellybooks architecture.

**Open details.** Number and kinds of secrets, who needs access, compliance obligations, existing CI system, whether a cloud KMS is available, and availability requirements for a central service. They do not block the tutorial; the decision chapter shows how they change the choice.
