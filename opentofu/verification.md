# Verification record

Target: OpenTofu 1.13.0 on Linux amd64; hashicorp/local 2.5.3; research and execution on 21 October 2026.

## Technical sources

Consequential semantics were checked against official versioned OpenTofu 1.13 documentation, the tagged engine apply source, and the tagged local provider documentation. Citations are beside the relevant claims in the tutorial. The engine archive was downloaded from the official GitHub release and its SHA-256 matched the published release checksum file; this was a checksum check, not an independent signature verification.

OpenTofu/Terraform compatibility is deliberately bounded to exact versions. The current interdependent-configuration migration guide is more recent than the FAQ's older compatibility wording; the tutorial avoids a blanket bidirectional compatibility claim. OpenTofu S3 locking is described using OpenTofu's policy, including continued DynamoDB support, rather than Terraform's different policy.

## Executed local examples

Execution used disposable copies, not live infrastructure. Provider installation reported the package signed by HashiCorp's key. No cloud credentials were required.

- `tofu fmt -check -recursive` checks the example formatting.
- All three roots were initialised and their configurations validated.
- Manifest: initial plan/apply created one local file; unchanged repeat plan exited 0. An independent JSON parse confirmed the expected host address. External file editing made the pinned provider report missing tracked content and propose creation; applying restored the JSON and repetition was empty.
- Manifest `tofu test`: both tests passed, including the expected rejection of an unsupported role. Each run explicitly uses `command = plan`.
- Lifecycle: initial plan/apply created two instances; unchanged repeat plan exited 0. From that baseline, the role variant planned one in-place update, the revision variant one destroy/create replacement, and the other instance remained unchanged. These variants were planned, not applied.
- Refactor: a temporary resource-block rename plus a `moved` block produced two no-op actions at new addresses, preserving identity. This was planned, not applied.
- Failure: fresh planning proposed both resources; apply exited 1 after creating the first and failing the second's deferred precondition. `state list` contained only `terraform_data.first`. A new plan with `allow_second=true` retained the first and created only the second; applying succeeded and the corrected repeat plan exited 0.

Plan assertions examined `tofu show -json` output, including per-resource action lists. The tutorial includes the consequential expected observations, so it does not rely on execution logs.

## Publication checks

- `make -C opentofu` succeeded with Pandoc and XeLaTeX; the delivered PDF was rebuilt after the final source/layout changes. It has 45 pages, a compact linked contents page, 160 × 230 mm pages, 12-point Latin Modern Roman and Latin Modern Mono code.
- All 45 final pages were rendered and visually inspected in contact sheets. Contents and appendix numbering are consistent, short code blocks are kept whole on one page, and extracted text bounding boxes showed no horizontal clipping. Long code samples and tables can continue across pages.
- Markdown checks inspected all 16 paired code fences, table structure, Pandoc's parsed headers and links, and supporting-file references. The three complete configuration blocks and the test block match their supplied files. There are ten numbered chapters; authoring context remains outside the tutorial.
- All 44 distinct external source URLs, including the input-precedence fragment URL, returned HTTP 200. Local supporting references exist. HTTP resolution checks complement, rather than replace, the source checks described above.
- `git diff --check HEAD` passed.

## Limits

No cloud resource was deployed. Cloud import syntax is an illustration without a complete provider/resource configuration. Remote backends, competing writers, encryption/key recovery, backend migration, real fleet adoption, SSH/cloud-init, and Terraform engine migration were not executed. These need provider-specific isolated acceptance tests before operational use. The dependency lock was installed and exercised on Linux amd64; other runner platforms were not tested.
