# Learner brief

**Learner.** Jeff is an experienced Linux SRE with good Python skills, reasonably comfortable with Docker and still learning it. Terraform is a near-term learning goal. Assumed: no prior Ansible experience, so introduce Ansible from first principles without repeating basic Linux, SSH or programming instruction.

**Intended work.** Configure personal-project hosts and a Jellybooks fleet of roughly 30–50 hosts, including services that do not run in Docker. Terraform will eventually create infrastructure. A later move towards “a pod” is planned; its platform and meaning are unspecified and are not assumed to be Kubernetes.

**Desired outcomes.** Explain and predict execution and repeat runs; choose inventory, configuration ownership and role boundaries; direct an agent's implementation; review targeting, service lifecycle, secret handling and rollout safety; diagnose and recover from partial completion using evidence.

**Retained decisions.** Inferred from the intended collaboration: architecture, environment separation, ownership across Terraform/Ansible/Docker, acceptable disruption, access and secrets policies, deployment and recovery criteria. Mechanical implementation can be delegated; these policies require Jeff's judgement.

**Reading.** A substantial 2–3 hour tutorial with worked examples and review exercises, read offline on a tablet on a plane. No terminal or external page is required to learn.

**Agreed deliverable.** A tablet-friendly PDF with editable Markdown source, built locally using Pandoc and XeLaTeX. Markdown suits code-heavy material and easy revision. Body text is Latin Modern Roman at 12 point and code is Latin Modern Mono, for tablet readability.

**Target.** Ansible Core 2.21.5; controller Python 3.12; concrete managed-host example Ubuntu 24.04 LTS with systemd, Python 3 and SSH. The distribution is an explicit teaching assumption, not a claim about Jellybooks. Other distributions require package, service, path and interpreter checks.

**Research.** 20 October 2026. Official Ansible documentation and module documentation are primary sources. The mutable `latest` documentation URLs are dated accordingly.

**Scope.** Host configuration, inventory, variables, handlers, roles, verification, staged changes, partial failure, secrets, inherited repositories and infrastructure ownership. Terraform language, Docker fundamentals, Kubernetes implementation, Windows, network devices and exhaustive plugin coverage are outside scope.

**Example.** Dedicated disposable status-service hosts running nginx outside Docker. This is a teaching fixture, not a proposed Jellybooks architecture. Runnable local exercises isolate execution semantics without root or managed machines. The full remote example needs disposable Ubuntu VMs and is labelled with verification limits.

**Open details.** Actual host distributions, service topology, availability objectives, access conventions and future pod platform. These do not block the chosen tutorial; production adoption must revisit them.
