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

- `make -C opentofu` succeeded with Pandoc and XeLaTeX; the delivered PDF was rebuilt after the final source/layout changes. It has 56 pages, a compact linked contents page, 160 × 230 mm pages, 12-point Latin Modern Roman and Latin Modern Mono code.
- The 45 pages of the 21 October build were rendered and visually inspected in contact sheets, as were the primer's pages on 3 November. Contents and appendix numbering are consistent, short code blocks are kept whole on one page, and extracted text bounding boxes showed no horizontal clipping. Long code samples and tables can continue across pages.
- Markdown checks inspected the 16 paired code fences of the 21 October text, table structure, Pandoc's parsed headers and links, and supporting-file references. The three complete configuration blocks and the test block match their supplied files. There are eleven numbered chapters; authoring context remains outside the tutorial.
- All 44 distinct external source URLs of the 21 October text, including the input-precedence fragment URL, returned HTTP 200. Local supporting references exist. HTTP resolution checks complement, rather than replace, the source checks described above.
- `git diff --check HEAD` passed.

## Reading primer, 3 November 2026

The parts of chapter 1 listed here ran under OpenTofu 1.13.0, from the release archive with its published checksum matched, in temporary directories with local state. The `~> 2.5` constraint installed hashicorp/local 2.9.1 rather than the pinned 2.5.3 used by the labs. No cloud resource or remote backend was involved. Observations:

- The hello configuration needed only `init` and `apply`, printed the output shown and left `terraform.tfstate`.
- A configuration using `variable` with `validation`, `locals`, `output` with `sensitive`, `data`, `module`, `count`, `for_each`, `depends_on`, `lifecycle`, a heredoc, `required_providers` and `provider` passed `validate`, `fmt -check` and `apply`. `state list` gave the address forms shown, including the module's, and `tofu output` showed `<sensitive>`.
- `tofu console` returned the expected values for the `for` forms, `join`, `lookup`, `merge`, `coalesce`, `try` and `format`, and `(sensitive value)` for a sensitive variable. A conditional, a filter and a splat ran in the applied configuration.
- `TF_VAR_region`, `-var`, `terraform.tfvars` and `*.auto.tfvars` each took effect, and `*.auto.tfvars` beat `terraform.tfvars`. An out-of-range `-var` stopped at the validation error. A `.tofu` file replaced the `.tf` file with the same stem.
- Plans showed each of the tabled symbols, `(sensitive value)`, `(known after apply)`, `-> null`, the `count` reason line and the replacement excerpt, which is shortened. `No changes.` appeared for an unchanged configuration, and `# forces replacement` for a changed `local_file`. `moved` showed as moved, `removed` with `destroy = false` as forgotten, `check` as a warning, `-replace` as a replacement, and a `-target` left invalid by a `moved` block as an error. `-detailed-exitcode` returned 2 with changes pending. `tofu providers` and the lock file's registry address were as described.

**Not run, and following the documentation:** the `Objects have changed outside of OpenTofu` heading (a deleted local file produced only a create), `lifecycle { enabled }` and `provider::` calls in this run, `dynamic`, `%{ }` output layout, `precondition` and `postcondition` in this run (the partial-failure lab exercises a deferred precondition), `provisioner`, `connection`, `ephemeral`, remote module sources, `override.tf`, `*.tf.json`, `optional(...)`, `any`, `-var-file`, `tofu state mv` and `rm`, `import`, the warning from a valid `-target`, `tofu taint`, `null_resource`, `backend`, provider aliases, `prevent_destroy` and `replace_triggered_by`.

The primer's three new documentation URLs returned HTTP 200. Exercise and answer links were followed in the PDF from each link annotation to the text at its destination: 10 links each way, all landing on the right text.

On 3 November 2026, chapter and section numbers, the title, subtitle and date moved into the Markdown so that it reads on GitHub. Comparing the rebuilt PDF's text with the previous build showed only heading punctuation and consequent line breaks. All links were traced again and land on the right text.

## Limits

No cloud resource was deployed. Cloud import syntax is an illustration without a complete provider/resource configuration. Remote backends, competing writers, encryption/key recovery, backend migration, real fleet adoption, SSH/cloud-init, and Terraform engine migration were not executed. These need provider-specific isolated acceptance tests before operational use. The dependency lock was installed and exercised on Linux amd64; other runner platforms were not tested.
