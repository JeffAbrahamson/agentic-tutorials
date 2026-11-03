# Verification record

Target: Hugo 0.168.0 standard edition on Linux amd64; research and execution on
21 October 2026, and on 3 November 2026 for the reading primer.

## Technical sources

Consequential behaviour was checked against official Hugo documentation and the
official v0.168.0 release. Citations are beside the relevant claims in the
tutorial. The target release archive was downloaded from the official GitHub
release. Its SHA-256 digest,
`fada83ad56bb27ed4cb7dd81590303bdac16140f944ac4e66fc248117e2d5594`,
matched the official checksum list. This was a checksum comparison, not an
independent signature verification.

Research used the post-v0.146 template-system documentation where older official
pages still show legacy `_default` examples. Hugo 0.168.0 execution confirmed
the current paths used by the fixtures. Current edition, deprecation, security,
content-adapter, remote-resource, cache, theme-component, module, mount, output,
and diagnostic claims were checked against the linked official pages.

## Executed examples

Both fixtures were built into disposable `/tmp` destinations with Hugo 0.168.0,
`--noBuildLock`, `--printPathWarnings`, and `--panicOnWarning`. Lens Vault
additionally used `--clock 2026-10-21T12:00:00+02:00` to bound date-sensitive
output.

- Green Horizon built 23 pages with no warning or path collision. Generated
  output contains campaign, issue, and place routes; campaign evidence parsed
  from bundle JSON; the project's `data-urgency="high"` theme override; and a
  content-fingerprinted stylesheet.
- Lens Vault built seven pages with no warning or path collision. Its content
  adapter produced both album pages from the checked-in snapshot. Independent
  `jq` assertions confirmed two records in `/catalog.json` and the expected
  first route. Generated album HTML contains the two expected responsive
  rendition URLs, caller-specific `sizes`, and intrinsic dimensions. Its
  stylesheet is fingerprinted.
- Rebuilding Lens Vault into an existing destination removed an injected stale
  `stale.html`, confirming the configured clean-destination behaviour.
- Disposable Green Horizon copies failed with the specified errors when one
  campaign's `evidence.json` was missing, when its evidence array was empty, and
  when a record omitted required fields. This confirms that absent or incomplete
  required evidence stops the build rather than silently publishing an empty or
  misleading register.
- `hugo config mounts` showed the project component layer before the local
  `field-notes` theme, with project content/layout mounts and theme asset/layout
  mounts.

Running `--printUnusedTemplates` on Lens Vault, with and without
`--panicOnWarning`, reported nothing; `--templateMetrics` listed
`home.catalog.json` as executed. A deliberately unused template added to a
scratch copy was reported, so the flag works.

With `--clock`, the catalogue's `generated` value began at the given time but
drifted by milliseconds (`2026-10-21T12:00:00.02…+02:00`), so the file is not
byte-reproducible.

In scratch copies, a mount using `lang` failed the 0.168.0 build with
"deprecated … subsequently removed"; a page template with an HTML comment
before its `define` produced a two-byte page; `.Site.Data` and
`resources.PostProcess` logged deprecation warnings; `.Scratch` logged none.

## Reading primer, 3 November 2026

The parts of chapter 1 listed here ran under the same Hugo 0.168.0 archive, with its digest matched again, in scratch sites. Observations:

- The hello site built with the three files shown, and `public/index.html` matched the output shown. The build also wrote `index.xml`, `sitemap.xml` and taxonomy feeds, and logged the `WARN` shown.
- A second site exercised `baseof.html`, `home.html`, `section.html`, `page.html`, `taxonomy.html`, `term.html`, `_partials/`, `_shortcodes/` and `_markup/`, plus a type-specific `posts/page.html`. Page kinds, `slug`, a draft's exclusion and `--buildDrafts`, and `.Resources` behaved as described.
- `if`, `range` with `else`, `with`, `:=` and `=`, `-` trimming, `$`, `dict`, `slice`, `index`, `default`, `where`, `first`, `sort`, pipes, `partial` with and without `dict`, `return`, `partialCached`, `.Store`, `try` (on a refused connection) and `block` with `define` gave the expected output. `{{ "<b>" }}` printed `&lt;b&gt;`, and `safeHTML` removed the escaping.
- `{{< >}}` passed its output through with the inner `*text*` unrendered. `{{% %}}` output had its `<aside>` replaced by `<!-- raw HTML omitted -->`.
- `errorf` and `.Nope` failed the build, with rendering continuing past `errorf`; `warnf` logged `WARN` and built; a missing resource piped into `minify` failed the build; and `.Params.nope` printed nothing. `hugo env`, `hugo list all` and `hugo config` ran. The totals table is shortened from a real run, whose `Pages` count of 13 exceeded the six content files.

**Not run, and following the documentation:** `hugo server` and its environment default, `hugo mod`, `--gc`, `{{ T }}`, `relref`, `publishDate`, `expiryDate`, `aliases`, `cascade`, `.Plain`, `{{ template }}`, menus, pagination, `.Translations`, `markdownify`, `.RenderString`, `relURL`, `append` and `else with` as a form. `single.html`, `list.html`, `all.html`, `_default/`, `partials/` and `headless` also built on this binary. `hugo config mounts` and `--panicOnWarning` ran on 21 October, as recorded above.

Exercise and answer links were checked with Pandoc's GitHub-flavoured reader: each of the 18 links has a target. Each answer heading's automatic id `exercise-N` duplicates its exercise's span. The span comes first in the document, so it is the one a browser uses, and this was not followed on GitHub on this date.

## Publication checks

- Pandoc parsed the tutorial as GitHub-flavoured Markdown and rendered it to
  standalone HTML. Code fences are paired, tables parse, headings produce the
  internal anchors referenced from `README.md`, and all local supporting paths
  exist.
- Tutorial code excerpts for the content adapter, evidence resource, stylesheet
  pipeline, and catalogue output match the supplied runnable files in
  consequential behaviour.
- The official documented site-audit environment was used for fresh builds of
  both fixtures. A case-insensitive scan found none of its raw-HTML, unsafe
  template, missing-translation, nil, or broken-shortcode markers.
- `git diff --check HEAD` passed after the final source changes.

## Limits

The photo API and rendition URLs use the reserved `.example` domain; no remote
fetch, authentication, live edit, image download, or backend failure was
executed. The fixtures exercise data-to-page generation and responsive markup,
not actual image delivery or Hugo image transformation. No remote Hugo Module,
multilingual site, Dart Sass/Node pipeline, cloud deployment, or atomic host
promotion was exercised.

No HTML conformance, link crawler, accessibility engine, or browser was
available locally. Generated HTML and JSON received focused structural checks,
but visual layout, keyboard behaviour, assistive-technology behaviour, external
source availability, and hosting headers remain unproved. Those checks belong
in a real site's acceptance pipeline with its actual theme, content, browsers,
backend, and deployment target.
