# Ansible: from one host to a fleet

The tutorial is [ansible.pdf](ansible.pdf): a 2–3 hour read, with prediction exercises and worked answers, covering execution, inventory, roles, verification, fleet rollouts and recovery from partial completion.

The source is [tutorial.md](tutorial.md). Its scope and teaching assumptions are recorded in [brief.md](brief.md) and [outline.md](outline.md). The target is Ansible Core 2.21.5; concrete remote examples assume dedicated Ubuntu 24.04 VMs with systemd.

## Build the PDF

Required tools: GNU Make, Pandoc, XeLaTeX, and the Latin Modern Roman and Latin Modern Mono fonts. The TeX installation needs the packages used by Pandoc's default LaTeX template, plus `fvextra`, `microtype`, `ragged2e`, `etoolbox` and `needspace`. On Debian/Ubuntu, the usual packages are `make`, `pandoc`, `texlive-xetex`, `texlive-latex-extra`, `texlive-fonts-recommended` and `fonts-lmodern`. No network access is required once the toolchain is installed.

From the repository root:

```sh
make -C ansible
```

This produces `ansible/ansible.pdf`. Its 160 × 230 mm single-column pages use 12-point Latin Modern Roman body text, Latin Modern Mono for code, a linked contents page, selectable text and wrapping code. The PDF is retained alongside its source; temporary files live in ignored `.build/`. Editing the source and running Make rebuilds the deliverable. The PDF uses Markdown source, rather than a separately maintained LaTeX document; [pdf-header.tex](pdf-header.tex) supplies small typesetting adjustments, and [code-breaks.lua](code-breaks.lua) lets inline code break only at separators such as `/`, `.` and `_`, never mid-word.

## Examples

Read the setup and limitations in chapter 5 before executing remote examples. The remote role replaces the **complete nginx configuration** and belongs only on dedicated disposable VMs. Addresses in the supplied inventory are documentation placeholders.

The example entry points and supporting files are:

- [Pinned engine](examples/requirements.txt) and [controller configuration](examples/ansible.cfg).
- [Lab inventory](examples/inventories/lab/hosts.yml), [connection variables](examples/inventories/lab/group_vars/all.yml) and [service variables](examples/inventories/lab/group_vars/status.yml).
- [Remote playbook](examples/site.yml), [role defaults](examples/roles/status_service/defaults/main.yml), [tasks](examples/roles/status_service/tasks/main.yml), [handler](examples/roles/status_service/handlers/main.yml) and [complete nginx template](examples/roles/status_service/templates/nginx.conf.j2).
- [Rootless local convergence exercise](examples/local/converge.yml) and [deliberate handler-failure exercise](examples/local/handler-gap.yml).

Run commands from `ansible/examples/`, with the virtual environment described in the tutorial activated. The local exercises only write beneath `examples/local/.state/` by default and need no remote systems or root privilege. Their state persists between invocations. Chapter 7 explains how to use a new private directory for an independent handler-gap experiment.

[verification.md](verification.md) records what actually ran and what remains untested. In particular, the complete SSH/sudo/systemd play has not been executed on full VMs; container tests do not replace that acceptance test.
