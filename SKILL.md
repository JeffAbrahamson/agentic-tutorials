---
name: agentic-tutorials
description: Create personalised technical tutorials for learners who direct, question, and review work implemented with an LLM agent. Use when generating or revising a tutorial for that collaboration role.
---

# Tutorials for collaborating with agents

Generate a tutorial that enables the learner to explain behaviour, make design decisions, specify work, review generated implementations, and verify outcomes. Use code to make those abilities concrete. Do not equate competence with memorising syntax or completeness with exhaustive feature coverage.

The learner expects to delegate much of the implementation. Preserve the technical explanations they need to judge that implementation; do not replace them with management advice, checklists, or stock prompts.

Assume from the outset that the learner is an experienced Linux SRE and an experienced C++ and Python developer, with a PhD in mathematics and theoretical computer science. Use this background to calibrate explanations and comparisons without asking the learner to establish it again. Subject-specific knowledge still needs to be established where it affects the tutorial.

## Workflow

Interview → save the learner brief → establish an outline → research → write → verify → review.

For an existing tutorial, read its brief and content first. Reuse established preferences and ask only about material gaps or changed requirements.

### 1. Interview and agree the format

Use the request and available project context before asking questions. Ask a small batch of focused questions whose answers materially change scope, depth, examples, or presentation. Establish:

- The subject and intended work: what the learner wants to build, maintain, migrate, or diagnose, and whether there is an existing system to understand.
- Relevant subject-specific experience, unfamiliar concepts, and useful comparisons with tools they already know, building on the assumed background above.
- The decisions they want to retain and the work they expect to delegate to an agent.
- Constraints that affect the teaching: versions, environment, scale, security or operational needs, available study time, desired depth, and reading or exercise preferences.
- Concrete outcomes: what they should be able to explain, decide, review, and verify afterwards.

Stop the interview when you can choose the scope, progression, representative example, and format. Follow up only on gaps that would materially alter those choices. State reasonable assumptions for minor unknowns; do not prolong the interview to collect every possible preference.

At the end of the interview, recommend Markdown or LaTeX and explain the tradeoff for this tutorial. Prefer Markdown for repository reading, easy revision, and code-heavy material; consider LaTeX when mathematical notation, typesetting, cross-references, or a print-oriented PDF materially improve the result. Make a reasoned choice rather than treating either format as mandatory.

Present the recommendation with a concise summary of the agreed scope and **ask the learner to confirm the format**. Wait for that confirmation before generating the tutorial. An explicit format choice already supplied by the learner satisfies this requirement; acknowledge it without asking again.

### 2. Save the brief and establish the outline

Persist a concise learner brief containing the goals, prior knowledge, intended work, retained decisions, constraints, target versions, agreed format, and any assumptions or open questions. Additional personal details and subject-specific experience belong in this brief; the baseline background above may be assumed for every tutorial.

Organise the outline around capabilities and decisions. Use this progression as a guide:

1. A reading primer for the technology's notation and everyday constructs (see "Open with a reading primer" below).
2. Fundamentals and a predictive mental model.
3. Routine work with a small, coherent example.
4. Design and maintenance as the system grows.
5. Diagnosis, partial failure, and recovery.
6. Advanced topics relevant to the learner's intended work.

Introduce verification and failure behaviour throughout, even when they also deserve dedicated chapters. Make specialised features optional branches with a reason to read them and clear prerequisites.

For each substantial chapter, identify the learning outcome and answer: **“What can I now judge that I could not judge before?”** The primer answers a different question: **“What can I now read?”** Map the outline to the brief so that essential outcomes are covered and irrelevant feature tours are omitted. Save the outline with the tutorial artifacts; do not require a separate approval unless the learner requests it or a material scope question remains.

### 3. Research authoritative behaviour

Establish the version and environment the tutorial targets. Use official documentation, release notes, specifications, and maintained upstream examples as primary sources. Verify version-sensitive interfaces, defaults, execution semantics, limitations, and deprecations rather than relying on remembered behaviour.

Research the consequential claims and examples in the outline before drafting; return to sources as new questions arise. Link sources near the claims they support and record the target version and research date. Distinguish documented guarantees, conventions, and your own recommendations.

If browsing or the relevant environment is unavailable, state what could not be verified, use available local or supplied authoritative material, and label remaining uncertainty. Do not claim current behaviour, tested examples, or source verification without evidence. Ask for missing material only when it is necessary to teach a core outcome reliably; otherwise bound the scope and explain the limitation.

### 4. Write for technical judgement

Build a coherent explanation from fundamentals to realistic work. Use familiar concepts as bridges, explicitly identifying where analogies stop being accurate. Introduce terms before relying on them, and give enough causal explanation for the learner to predict behaviour.

**Open with a reading primer.** Chapter 1 teaches the learner to read the technology, because reviewing generated work starts with being able to parse it. This is reading fluency, not the writing fluency or memorised syntax the tutorial otherwise avoids. Its test: shown an ordinary file, command, or output from a real project, the learner can say what kind of thing each construct is, roughly what it does, and what name to look up or ask about. Judging whether it is right is left to later chapters.

Survey the technology as the first pages of a language tutorial would, covering whichever of these apply:

- The smallest complete example, how to run it, and what it prints: hello world.
- Core forms: how to set and use a value, define and call the unit of reuse, branch, iterate, handle errors, and write the common data structures. If the technology lacks one of these, say so and show what people do instead.
- Idioms and shorthands too common to skip and too dense to guess, such as Python's comprehensions.
- Names, punctuation, and file locations that carry meaning by rule or convention, such as Python's leading underscores and double underscores.
- Look-alikes: constructs that seem to do the same job, why both exist, and when each is used, such as Python's `__slots__` and `__dict__`.
- Where the artefacts live, and the everyday commands that act on them.

When the technology has no language of its own, as with a message broker, apply the same survey to what its users actually read: configuration, command lines, client API calls, output, and vocabulary.

Choose items by how often they appear in real projects and how hard they are to guess, not only by what later chapters use. A construct common in the wild belongs here even if the running example never needs it. Teach this technology's notation rather than general programming, using the assumed background for comparisons.

Keep each item brief, but set no target length for the chapter: it takes what the subject's complexity needs. Give most items a sentence and a minimal example of a few lines. When an item needs more, say just enough to recognise it and point to the chapter that explains it, rather than anticipating that chapter's causal explanation. Examples may stand alone instead of using the running example. The primer needs no exercises, questions for an agent, or the causal explanation required of other samples, though its claims and examples are verified like any others. Omit or shorten it only when the brief records that the learner already reads the technology fluently.

Cover the following where applicable to the subject and learner's goals:

- **Purpose and boundaries.** Explain the problem the tool solves, when it is a good fit or unnecessary, what it cannot guarantee, and where another tool should own part of the problem.
- **Execution and state.** Explain where execution occurs, how state is represented, ordering, scope, dependencies, failure propagation, retries, and repeat execution. Walk through short examples so the learner can predict results, including partial completion and a second run.
- **Design decisions.** Distinguish mechanical details that can usually be delegated, established conventions an agent should normally follow, architectural decisions the learner should discuss and approve, and context-dependent tradeoffs requiring evidence. For consequential choices, compare alternatives and the circumstances favouring each.
- **Patterns and growth.** Explain idiomatic solutions and the pressures that justify more structure: environments, ownership, reuse, secrets, dependencies, testing, and operational constraints. Show how a small example evolves and why each added layer is needed. Include reading inherited conventions and making bounded changes to an existing system.
- **Antipatterns and plausible generated mistakes.** Show convincing-looking implementations with faulty assumptions, obsolete interfaces, unnecessary abstraction, or inappropriate defaults. Ground each problem in actual tool behaviour and show how to detect and correct it. Avoid unsupported claims about what models always do.
- **Verification.** Explain what inspection, automated tests, dry runs, and realistic execution each establish and what they leave unproven. Include successful runs that still produce an unacceptable result, such as changing the wrong target, hiding drift, exposing secrets, or failing on repetition. Successful execution is evidence, not a complete acceptance criterion.
- **Diagnosis and recovery.** Connect symptoms to possible causes and evidence that distinguishes them. Identify logs, outputs, or state to inspect before changing code. Cover recovery from partial completion and rollback limits; demonstrate investigation rather than repeated unsupported edits.

Use short, realistic code samples with the relevant context, assumptions, expected behaviour, and explanation of why they work. Prefer a running example when it helps connect concepts. Label excerpts, pseudocode, and untested samples clearly; provide required files and commands when presenting an example as runnable. Do not require extensive typing to demonstrate understanding.

For each substantial topic, include useful questions the learner can ask an agent, the evidence a good answer should contain, and warning signs in a weak answer. Tie these to the topic's actual behaviour and tradeoffs. For example, a question about interrupted execution should lead to an explanation of intermediate state, a way to inspect it, and a supported recovery strategy.

Use exercises that match the learner's role: predict a result, review a proposed change, choose between designs under stated constraints, diagnose output, or write acceptance criteria. Provide worked answers or reasoning separately so the learner can attempt the exercise first. Any code-writing exercise should serve understanding rather than syntax fluency.

Link each exercise to its worked answer and each answer back to its exercise, wording both links so the text still makes sense where links do nothing: `[Worked answer](#answer-1)` and `[Back to exercise 1](#exercise-1)`. A link must land with its title in view, so its target goes before any heading. In Markdown, make the targets work both on GitHub and in a Pandoc PDF with an empty span: `<span id="answer-1"></span>` as its own paragraph immediately before the answer's heading, with the back link as the line under that heading. Treat the exercise the same way, or begin its first paragraph with the span if it has no heading. End the exercise with the forward link, as its own paragraph if the exercise closes with a list. Do not put the span inside a heading, because the PDF link is left undefined. A Pandoc PDF build also needs a Lua filter, because a page break can otherwise separate an anchor from its text: it moves such a span's id onto the heading that follows, and starts the paragraph before a leading span with `\leavevmode`. An existing tutorial's `span-markers.lua` does this; copy it into the tutorial's directory. In LaTeX source, use `\label` directly after a sectioning command, `\leavevmode\phantomsection\label` at the start of a target with no heading, and `\hyperref` for the links.

Keep Pandoc attributes such as `{#id}` and `{.unnumbered}` out of Markdown headings, because GitHub shows them as literal text. Give a heading an id only when something links to it, using the span above, and mark an unnumbered heading with `<span class="unnumbered"></span>` as its own paragraph before it; the same filter applies both.

Keep the brief, the interview, and this skill out of the tutorial's text. The brief shapes scope, depth, examples, and format; it is not content. Do not address the learner by name, tell them about their own background or plans, mention where or how they will read, or refer to what the interview did or did not establish. State assumptions as properties of the material: "Examples assume Ubuntu 24.04", not "your distribution was not specified". Do not reproduce this skill's wording or process, such as closing answers with what the learner "can now judge" or describing how the tutorial was written or reviewed. Pointers to supporting files and statements of verification limits remain required. Label excerpts and untested samples once and briefly; do not repeat disclaimers that an example is not a recommendation.

### 5. Package and verify

Keep **one root-level entry per tutorial**:

- A standalone Markdown tutorial may be a single root-level `.md` file. Embed the learner brief and outline in that file, for example in concise appendices, so they do not create extra root entries.
- If Markdown needs supporting files, put the tutorial, brief, outline, examples, and assets in one subdirectory.
- For LaTeX, always create a subdirectory containing the source, supporting files, learner brief, outline, a Makefile, and the compiled PDF. Provide a working `make` target that builds the PDF and document the required toolchain. Keep the PDF version-controlled alongside its source and include it whenever the tutorial is committed.

Choose names that make the subject clear. Keep generated intermediates out of version control while retaining the required PDF. Do not place a shared top-level example or asset beside a standalone tutorial if that would give the tutorial multiple root entries.

Verify according to the deliverable:

- Check technical claims against the researched sources and target version. Execute runnable examples where feasible in an appropriate isolated environment; compare observed behaviour with the explanation, including failure or repeat-run behaviour when it is central to the lesson. Do not execute examples against live systems merely to validate the prose.
- For Markdown, check rendering-sensitive syntax, code fences, tables, internal links, and supporting file references with available tools. Confirm that exercise and answer links land on their targets in both directions, including in any PDF, where an undefined reference is only a warning and a misplaced anchor gives none.
- For LaTeX, build through the Makefile, resolve errors and broken references, and inspect the PDF for readability, clipped code, and layout problems. Rebuild after source changes so the committed PDF matches the source.
- Check citations and internal cross-references, and ensure each supporting artifact is reachable from the tutorial. After inserting or renumbering a chapter, search the whole tutorial directory for chapter and section references, including comments and help text in examples, not only the tutorial's own text.

Report which checks actually ran, their results, and any remaining limits. If a required build or check cannot run, identify the missing prerequisite and leave the deliverable explicitly incomplete rather than claiming verification. A verification record kept with the tutorial states what was checked and what it showed; it omits session history such as sandbox workarounds, review rounds, or who approved which change.

### 6. Review the teaching and deliver

Review the finished tutorial against the learner brief as well as technical correctness. Revise any chapter that:

- Assumes unexplained prerequisites or teaches a misleading mental model.
- Uses a construct that neither the primer covers nor the chapter explains where it appears, or leaves the primer short of its reading test.
- Echoes the brief, the interview, or this skill instead of teaching the subject.
- Provides code without explaining the consequential behaviour or tradeoff.
- Treats one example architecture as universally correct.
- Gives review questions without showing what adequate evidence looks like.
- Adds complexity without explaining the pressure that justifies it.
- Leaves the learner unable to predict behaviour, assess a proposal, or verify an outcome promised in the outline.

Ensure the progression is coherent, optional advanced material is clearly signposted, and exercises have usable reasoning. Deliver the tutorial with its artifact paths, target version, completed verification, and material limitations. Keep the final handoff concise; the tutorial itself carries the teaching.
