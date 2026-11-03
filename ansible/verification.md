# Verification record

Dates: 20–21 October 2026. Target and executed controller: `ansible-core==2.21.5`, Python 3.12.3 on Linux. Sources are linked beside claims in the tutorial. Official module documentation and version support were checked; selected installed module help was also available from the pinned engine.

## Observed execution

The remote `site.yml` passed `--syntax-check` with its supplied lab inventory. Inventory graph and merged host data were inspected. The named-canary limit selected one intended inventory alias without contacting a remote machine. Documentation addresses were never used as live targets.

The supplied local exercises ran with a temporary virtual environment. Ansible's home and local temporary directories were redirected to `/tmp`; the exercises themselves wrote only their private `examples/local/.state/` directories.

| Exercise | Actual observation |
| --- | --- |
| Fresh convergence | Exit 0; `changed=3`: directory, desired message and handler output |
| Immediate repeat | Exit 0; `changed=0`; no handler execution; content assertion passed |
| Change message from `r1` to `r2` | Exit 0; `changed=2`; desired and applied files contained `r2` |
| Check/diff for `r3` on existing state | Exit 0; predicted `changed=2`; both files still contained `r2` afterwards |
| First handler-gap run | Expected exit 2; disk file written; deliberate later failure; applied file absent |
| Rerun with failure disabled | Exit 0; `changed=0`; handler absent; applied file still absent |
| Explicit recovery | Exit 0; `changed=1`; applied file now contained `r2` |

All supplied playbooks passed syntax checks. The full remote play was also checked with the lab inventory, rather than relying on a local inventory that does not contain its host group.

The actual nginx template was rendered through the pinned Ansible template module for releases `r1` and `r2`. A disposable `ubuntu:24.04` Docker container installed Ubuntu's nginx `1.24.0-2ubuntu7.18` package, with package-triggered startup suppressed. No ports were published, no privileged mode was used, and only temporary fixture files were mounted, read-only. Observations:

- `nginx -t -c /r1.conf` accepted the complete rendered configuration.
- Starting nginx with that configuration served the exact `ok localhost r1` line, including its configured newline.
- Installing and validating the `r2` configuration, then reloading nginx, changed the response to `ok localhost r2`.
- An invalid candidate with an unknown directive was rejected; the live response remained `r2`.

The invalid-candidate check used nginx directly; it did not itself test the template module's candidate-before-replacement mechanism on a remote VM. That mechanism is a documented module property. The container was removed automatically after the check. The exact final-newline requirement was checked separately, below.

The actual health-query task was extracted from `site.yml` and run against a temporary loopback HTTP fixture. It accepted `ok localhost r1` with its final newline, rejected the same response without the newline, and rejected release `r2` when `r1` was expected. Only retries and delay were shortened for this fixture; the URI arguments and acceptance expression were unchanged.

## Revision checks, 21 October 2026

Three corrected claims were checked against the pinned 2.21.5 engine, without contacting any remote machine:

- `apt` with a named package returns a cache refresh as `cache_updated` and sets `changed` only from package state (`modules/apt.py`).
- Check mode skips a file task's `validate` command. A local `copy` task with `validate: /bin/false %s` reported `changed` under `--check` and failed validation only on a real run, leaving the destination unchanged.
- `--limit 192.0.2.11` against the lab inventory stopped with “no hosts to target” and exit 1. `-i '192.0.2.11,'` with `site.yml` printed “skipping: no hosts matched” and exited 0.
- The handler-gap sequence in a fresh `mktemp -d` directory passed as `-e lab_root=$D` gave exit 2 with only `disk.txt`, then `changed=0` with `applied.txt` still absent, then `changed=1` with `applied.txt` containing `r2`.

## Reading primer, 3 November 2026

Chapter 1's playbooks, expressions and inventory ran under `ansible-core==2.21.5` on Python 3.14.4, using `connection: local` and a temporary directory. No remote machine was contacted. The anatomy-of-a-play example, which needs apt and sudo on a real target, passed `--syntax-check` and `--list-hosts` only. The handler, `include_role` and user-loop excerpts are shown as task fragments; the same forms ran with local fixtures, apart from the `user` and `systemd_service` modules themselves. Observations:

- `hello.yml` with `-i localhost,` printed the output shown, with no inventory warnings.
- `mode: 644` produced file mode `1204`; `0644` and `'0644'` produced `644`. An unquoted value starting with `{{` stopped with a YAML parsing error. A variable called `name` drew a reserved-name warning.
- The filter chains, tests, `omit`, `lookup`, `block`/`rescue`/`always` and `!unsafe` gave the results described. The Jinja loop rendered one line per port. `ansible-vault encrypt_string` produced the `!vault` form. A `set_fact` inside an included task file remained visible to later tasks.
- A `vars` timestamp differed between two tasks, while a `set_fact` copy did not.
- `command` passed `| tr a b` to `echo` as text; `shell` ran the pipe. `--list-tasks` showed an imported file's task but only the `include_tasks` line for an include. A loop on `import_tasks` was rejected.
- With sections deliberately out of order in the file, execution ran `pre_tasks`, `roles`, `tasks`, handlers, `post_tasks`.
- An unreachable host (a closed local port) ran neither `rescue` nor `always`. `ansible-lint` rejected `status_port` and `__status_tmp` in a role called `status_service`, and accepted `status_service_port`.
- The engine reports removal of the braced `when` form in 2.23 and of default top-level fact injection in 2.24.
- The INI inventory expanded `web[01:03]`, and applied its `:vars` and `:children` sections, as described.

Claims about role layout, execution order, loops, `omit` and YAML quoting were also checked against the `stable-2.21` documentation source in the `ansible/ansible-documentation` repository, the variable-naming conventions against the `ansible-lint` rule source and the Red Hat CoP good-practices guide. `docs.ansible.com` returned HTTP 429, so the rendered pages cited in this chapter were not fetched on this date.

## Document checks

The nine exercises and their worked answers link to each other in both directions. The PDF build reported no undefined references, and tracing the PDF's link annotations took each of the 18 links to its target, with each answer's heading and each exercise's first line at the landing point. GitHub's rendered HTML kept all 18 targets and links, and following them in a browser worked. The headings carry no Pandoc attributes, and replacing those attributes left the PDF's extracted text and link positions unchanged.

`make -C ansible` built the final PDF successfully using Pandoc and XeLaTeX: 53 pages. `pdffonts` confirmed embedded Latin Modern Roman (12-point body), Latin Modern Mono and Latin Modern Math. The PDF uses 160 × 230 mm pages, selectable text, linked contents and wrapping code. Inline code breaks only at separators, through `code-breaks.lua`; when the filter was added, the extracted text, ignoring whitespace, page numbers and line-end hyphens, matched the previous build that allowed breaks anywhere, so the filter's escaping changed no characters. Bounding-box checks found no text outside the body margins plus a 6-point tolerance. Visual inspection covered the page layouts, code, tables, headings and contents.

Markdown was rendered with Pandoc to HTML and its document tree inspected. Code fences are balanced, supporting-file links resolve, and the five complete remote-play/role code blocks match their supplied files exactly. Tables and heading progression were inspected. `git diff --check HEAD` passed.

Citations were checked against the primary sources. A separate bulk HTTP link/fragment checker received HTTP 429 responses from the Ansible documentation host, so exhaustive HTTP/anchor validation is not claimed. Additional documentation pages were successfully checked through the research browser; HashiCorp, nginx and PyPI links resolved through the HTTP checker.

## Limits

No full Ubuntu VM was available for an end-to-end SSH/sudo/systemd run. The remote example is supplied as runnable under the stated prerequisites, not represented as end-to-end tested. The disposable-VM sequence in chapter 6 remains necessary before operational adoption. Boot enablement, target sudo policy, SSH host trust, external client paths, multi-host service availability and production secret handling were not exercised.

No `ansible-lint` run over the examples is claimed. The tutorial explains its place in an evidence ladder without presenting it as a performed check. Core is pinned; the example is not a lockfile for all transitive Python dependencies or Ubuntu package repositories. No live machines were changed.
