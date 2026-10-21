# OpenTofu: infrastructure, state and safe change

Read [opentofu.pdf](opentofu.pdf), a 45-page tutorial developing the execution and state model, HCL reading, plan review, resource identity, modules, shared operation, gradual adoption of existing infrastructure, and recovery. Ten exercises have separate worked answers. Allow 2–3 hours including the exercises.

The target is **OpenTofu 1.13.0**, researched on 21 October 2026. The local-file fixture uses **hashicorp/local 2.5.3**. No cloud platform is assumed. All explanations and expected lab behaviour are included in the PDF; a terminal or internet connection is unnecessary for reading.

The editable source is [tutorial.md](tutorial.md). Authoring context is kept separately in the [learner brief](brief.md) and [capability outline](outline.md). It is not included in the reading text.

## Rebuild

```sh
make -C opentofu
```

Run this from the repository root. It builds `opentofu/opentofu.pdf` using [Makefile](Makefile) and [pdf-header.tex](pdf-header.tex). Requirements: GNU Make, Pandoc, XeLaTeX, Latin Modern Roman and Latin Modern Mono, the packages required by Pandoc's default LaTeX template, plus `fvextra`, `microtype`, `ragged2e`, `seqsplit`, `etoolbox` and `needspace`. Typical Debian/Ubuntu packages are `make`, `pandoc`, `texlive-xetex`, `texlive-latex-extra`, `texlive-fonts-recommended` and `fonts-lmodern`.

The PDF uses 160 × 230 mm single-column pages, 12-point body text, selectable text, linked contents and wrapping code. Build intermediates stay in ignored `.build/`. The PDF is retained alongside the source.

## Examples and checks

The tutorial's lab guide links every example and gives setup, commands, expected results and cleanup. Use independent disposable copies; each directory is a separate root with its own local state.

- [Manifest](examples/manifest/main.tf): a real local-file provider, a non-secret handover schema, [provider lock](examples/manifest/.terraform.lock.hcl) and [plan-only tests](examples/manifest/tests/contract.tftest.hcl).
- [Lifecycle](examples/lifecycle/main.tf): built-in resources, a [role update](examples/lifecycle/update.tfvars), a [replacement](examples/lifecycle/replace.tfvars) and an identity-preserving refactor.
- [Partial failure](examples/partial-failure/main.tf): a deferred precondition that fails after the first resource succeeds, followed by recovery.

The manifest needs a provider download on first initialisation; the other labs use only the built-in provider. None creates cloud resources or contacts the documentation IP addresses. Cloud import snippets are explicitly incomplete illustrations, not deployment recipes.

See [verification.md](verification.md) for executed checks and material limits.
