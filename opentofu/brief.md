# Learner brief

**Learner.** Jeff has almost no Terraform/OpenTofu experience and knows SaltStack. Assume the repository baseline: experienced Linux SRE, C++ and Python developer, PhD in mathematics and theoretical computer science. Use Salt's desired-state vocabulary as a bridge, without treating resource state as a Salt highstate cache.

**Intended work.** Personal and nonprofit projects and the Jellybooks fleet (roughly 30–50 hosts from the existing Ansible brief), with a long transition from existing management. No cloud, hosting provider or existing Terraform repository has been specified. Do not invent those details or prescribe a cloud migration.

**Outcomes.** Predict plan/apply and repeat-run behaviour; understand configuration, state, remote objects and provider responsibilities; review identities, replacements, dependencies and target selection; choose state and module boundaries; bring existing infrastructure under management gradually; establish an OpenTofu/Ansible ownership contract; diagnose partial completion and verify recovery.

**Retained decisions.** Ownership and migration sequence, environment and state boundaries, credentials and secrets, disruption and replacement policy, dependencies, versions, acceptance and recovery criteria. Mechanical HCL and routine edits can be delegated to agents.

**Reading and format.** Confirmed 2–3 hours, offline on a tablet on a plane. PDF explicitly requested, satisfying format confirmation; editable Markdown source with a local Pandoc/XeLaTeX build. Reuse the established Ansible reading preference: 12-point Latin Modern Roman, Latin Modern Mono code, 160 × 230 mm pages. No terminal or linked page is needed to understand the teaching; exercises have separate worked answers. Subsequent explicit instruction: keep prompt, interview and skill content out of the reading text; retain authoring context only in separate brief/outline files.

**Target.** OpenTofu 1.13.0, Linux amd64 for executed examples, researched 21 October 2026. HCL examples retain `.tf` and `terraform` spellings. External provider fixture: hashicorp/local 2.5.3. Core language broadly transfers to Terraform but compatibility and state migration require checking exact versions. Experimental OpenTofu 1.13 features are outside scope.

**Example.** A small fictional status-service fleet represented by stable host keys and a generated, non-secret handover manifest. This is an isolated local teaching fixture, not Jellybooks topology or production inventory. Built-in-resource labs demonstrate lifecycle and deterministic partial failure without cloud credentials. Cloud-specific resources are discussed as conceptual cases, not untested deployable recipes.

**Scope and open details.** Core model; HCL reading; providers and locks; plan review; identity and refactoring; remote state and locking; security; modules; testing; drift; import and long migration; diagnosis and recovery; OpenTofu/Terraform choice. Actual provider, account layout, distributions, availability objectives and existing management remain unknown. Production designs must resolve them; they do not block this provider-neutral foundation.
