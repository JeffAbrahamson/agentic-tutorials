# Learner brief

**Learner.** Assume the repository baseline: an experienced Linux SRE and an
experienced C++ and Python developer with a PhD in mathematics and theoretical
computer science. The learner has used custom static-site generators and Hugo
only very superficially. Basic Markdown authoring is not a teaching goal.

**Intent.** Understand why Hugo is more than a Markdown-to-HTML converter and
what ambitious sites and theme systems can reasonably be designed with it.
The learner expects teams or agents to implement much of the code; the retained
work is choosing the content model, rendering boundaries, theme architecture,
data freshness contract, and acceptance evidence, then reviewing what was
built.

**Outcomes.** Explain Hugo as a compiler over a typed content graph and layered
virtual file system; predict page and template selection; distinguish content,
data, assets, and live application state; review use of page bundles, resources,
taxonomies, data, render hooks, output formats, and build-time API access; choose
between project overrides, theme components, Hugo Modules, and a bespoke theme;
diagnose lookup, scope, cache, stale-output, and deployment failures; verify
generated output rather than accepting a successful build as sufficient.

**Running examples.** Alternate between two deliberately non-blog sites:

1. an environmental advocacy organisation whose site connects campaigns,
   places, evidence, events, actions, and reusable policy material; and
2. a static front end for a photo-management backend, with albums and renditions
   snapshotted at build time while authenticated and rapidly changing behaviour
   remains owned by the backend or browser.

The supplied advocacy fixture uses a small local theme plus a project override,
illustrating how to inspect and modify an inherited theme. The supplied photo
fixture uses project-owned templates, illustrating a small theme architecture
from scratch. Both are teaching fixtures, not visual designs for production.

**Scope and progression.** Allow 2–3 hours including predictions, design
reviews, and worked answers. Start from the build graph and Hugo's content
model, then cover template dispatch and scope, data and resource pipelines,
themes and modules, multiple outputs, operational boundaries, diagnosis, and
verification. Theme implementation syntax is subordinate to understanding the
available architecture and evidence needed to direct a team.

**Target.** Hugo 0.168.0 on Linux, researched 21 October 2026. Examples use only
features available in any current edition. The former Extended-edition check is
disabled in Hugo 0.153.2 and later; embedded LibSass is deprecated, so a site
that needs modern Sass should treat Dart Sass as a separate toolchain
dependency. Go and Git are needed for remote Hugo Modules, not for these local
fixtures.

**Format.** Markdown explicitly confirmed. The tutorial, brief, outline,
verification record, and runnable examples live under the single root entry
`hugo/`.

**Assumptions and boundaries.** No particular CMS, photo API, deployment
platform, traffic profile, multilingual requirement, or existing theme has been
specified. The tutorial therefore teaches how those facts change a design
rather than inventing them. It does not teach HTML, CSS, Go template syntax,
graphic design, CMS operation, client-side application development, or provider-
specific deployment in depth. Remote API calls are discussed and shown as a
bounded pattern; the checked fixtures stay deterministic and offline.
