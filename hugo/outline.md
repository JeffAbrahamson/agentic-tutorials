# Capability outline

Allow 2–3 hours including the exercises and worked answers.

| Chapter | What can I now judge? | Brief coverage |
| --- | --- | --- |
| 1. Replace the converter model | Explain the build graph, component file systems, page kinds, and why one source can produce many related artifacts. | Hugo's source of power and its boundaries. |
| 2. Model a site as content | Choose sections, types, taxonomies, page bundles, resources, and headless content for advocacy and photo domains. | Non-blog examples and retained information architecture. |
| 3. Predict template dispatch | Determine which template wins from kind, type, layout, language, and output format; reason about base templates, blocks, partials, context, and cache scope. | Review generated themes instead of guessing at lookup order. |
| 4. Treat templates as queries | Review filtering, grouping, related content, data files, build-time API snapshots, content adapters, and explicit failure policy. | Where build-time computation belongs; static versus live data. |
| 5. Build an asset pipeline | Distinguish page, global, remote, and static resources; assess image rendition, CSS/JS transformation, fingerprinting, caching, and publication. | Photo front end and modern theme assets. |
| 6. Design theme boundaries | Choose project override, local theme, theme components, Hugo Modules, mounts, or a fork; understand precedence and configuration merging. | Modify an existing theme and direct a small bespoke one. |
| 7. Publish more than pages | Use output formats, render hooks, multilingual sites, and headless bundles where their extra complexity earns its keep. | API/search/feed outputs and content reuse. |
| 8. Operate and diagnose the build | Distinguish server and production builds, stale destinations, drafts, caches, remote failures, security boundaries, performance evidence, and rollback limits. | Failure, recovery, and production boundaries. |
| 9. Review and verify a change | Establish layered checks for configuration, templates, output structure, semantics, accessibility, links, assets, and deployment; review plausible agent mistakes. | Concrete acceptance evidence and delegation boundaries. |
| Worked answers | Compare predictions and design choices with causal reasoning. | Exercises are usable without writing theme code. |
| Field reference, fixture guide, and sources | Rebuild the examples, locate authoritative details, and see verification limits. | Reproducibility and versioned sources. |

Each substantial chapter contains a concrete prediction or review exercise and a
question for an implementation agent, with the evidence expected from a strong
answer and warning signs in a weak one. The two sites alternate as examples,
then converge in the theme and operational chapters where their different
pressures make trade-offs visible.
