# Verification record

Date: 20 October 2026. Target and executed controller: `ansible-core==2.21.5`, Python 3.12.3 on Linux. Sources are linked beside claims in the tutorial. Official module documentation and version support were checked; selected installed module help was also available from the pinned engine.

## Observed execution

The remote `site.yml` passed `--syntax-check` with its supplied lab inventory. Inventory graph and merged host data were inspected. The named-canary limit selected one intended inventory alias without contacting a remote machine. Documentation addresses were never used as live targets.

The supplied local exercises ran with a temporary virtual environment. Ansible's local RPC socket was blocked by the workspace sandbox, so actual local execution used the approved command outside that sandbox with Ansible's home and temporary directories redirected to `/tmp`. The exercises themselves wrote only their private `examples/local/.state/` directories.

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

The invalid-candidate check used nginx directly; it did not itself test the template module's candidate-before-replacement mechanism on a remote VM. That mechanism is a documented module property. The container was removed automatically after the check. The shell response comparisons checked the response markers; the exact newline requirement was checked separately below.

The actual health-query task was extracted from `site.yml` and run against a temporary loopback HTTP fixture. It accepted `ok localhost r1` with its final newline, rejected the same response without the newline, and rejected release `r2` when `r1` was expected. Only retries and delay were shortened for this fixture; the URI arguments and acceptance expression were unchanged.

## Document checks

`make -C ansible` built the final PDF successfully using Pandoc and XeLaTeX. The PDF uses 160 × 230 mm pages, selectable text, linked contents and wrapping code. Bounding-box checks found no text outside the body margins plus a 6-point tolerance. Visual inspection covered the page layouts, code, tables, headings and contents. Inline code and long headings were adjusted to prevent clipping; forced chapter breaks and a redundant final production note were removed to avoid nearly empty spillover pages.

Markdown was rendered with Pandoc to HTML and its document tree inspected. Code fences are balanced, supporting-file links resolve, and the five complete remote-play/role code blocks match their supplied files exactly. Tables and heading progression were inspected. `git diff --check HEAD` passed.

Citations were checked during primary-source research and independent review. A separate bulk HTTP link/fragment checker received HTTP 429 responses from the Ansible documentation host, so exhaustive HTTP/anchor validation is not claimed. Additional documentation pages were successfully checked through the research browser; HashiCorp, nginx and PyPI links resolved through the HTTP checker.

One fresh read-only review checked the diff against the learner brief, skill and cited technical sources. It found one P2 issue: describing a role as a namespace implied isolation of variables and handlers. The tutorial now describes roles as packaging/reuse boundaries and explicitly explains shared scope and distinctive naming. No other substantive findings were reported. Subsequent edits completed verification reporting and corrected PDF layout.

## Typography update

Jeff approved Latin Modern Roman at 12 point for body text and Latin Modern Mono for code. The Makefile, build dependencies and saved learner preference now match that choice. `make -C ansible` rebuilt the PDF successfully: 45 pages at the same 160 × 230 mm size. `pdffonts` confirmed embedded Latin Modern Roman, Mono and Math fonts, including the 12-point Roman face. Text bounding boxes stayed within the body margins plus a 6-point tolerance. All pages were visually inspected for layout, with code, tables and contents checked after reflow. `git diff --check HEAD` passed.

A fresh read-only review scoped to this typography change found no substantive issues. The tutorial's technical content and runnable examples were unchanged, so their earlier execution checks were not repeated.

## Limits

No full Ubuntu VM was available for an end-to-end SSH/sudo/systemd run. The remote example is supplied as runnable under the stated prerequisites, not represented as end-to-end tested. The disposable-VM sequence in chapter 5 remains necessary before operational adoption. Boot enablement, target sudo policy, SSH host trust, external client paths, multi-host service availability and production secret handling were not exercised.

No `ansible-lint` run is claimed. The tutorial explains its place in an evidence ladder without presenting it as a performed check. Core is pinned; the example is not a lockfile for all transitive Python dependencies or Ubuntu package repositories. No live machines were changed.
