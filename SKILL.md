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

1. Fundamentals and a predictive mental model.
2. Routine work with a small, coherent example.
3. Design and maintenance as the system grows.
4. Diagnosis, partial failure, and recovery.
5. Advanced topics relevant to the learner's intended work.

Introduce verification and failure behaviour throughout, even when they also deserve dedicated chapters. Make specialised features optional branches with a reason to read them and clear prerequisites.

For each substantial chapter, identify the learning outcome and answer: **“What can I now judge that I could not judge before?”** Map the outline to the brief so that essential outcomes are covered and irrelevant feature tours are omitted. Save the outline with the tutorial artifacts; do not require a separate approval unless the learner requests it or a material scope question remains.

### 3. Research authoritative behaviour

Establish the version and environment the tutorial targets. Use official documentation, release notes, specifications, and maintained upstream examples as primary sources. Verify version-sensitive interfaces, defaults, execution semantics, limitations, and deprecations rather than relying on remembered behaviour.

Research the consequential claims and examples in the outline before drafting; return to sources as new questions arise. Link sources near the claims they support and record the target version and research date. Distinguish documented guarantees, conventions, and your own recommendations.

If browsing or the relevant environment is unavailable, state what could not be verified, use available local or supplied authoritative material, and label remaining uncertainty. Do not claim current behaviour, tested examples, or source verification without evidence. Ask for missing material only when it is necessary to teach a core outcome reliably; otherwise bound the scope and explain the limitation.

### 4. Write for technical judgement

Build a coherent explanation from fundamentals to realistic work. Use familiar concepts as bridges, explicitly identifying where analogies stop being accurate. Introduce terms before relying on them, and give enough causal explanation for the learner to predict behaviour.

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

### 5. Package and verify

Keep **one root-level entry per tutorial**:

- A standalone Markdown tutorial may be a single root-level `.md` file. Embed the learner brief and outline in that file, for example in concise appendices, so they do not create extra root entries.
- If Markdown needs supporting files, put the tutorial, brief, outline, examples, and assets in one subdirectory.
- For LaTeX, always create a subdirectory containing the source, supporting files, learner brief, outline, a Makefile, and the compiled PDF. Provide a working `make` target that builds the PDF and document the required toolchain. Keep the PDF version-controlled alongside its source and include it whenever the tutorial is committed.

Choose names that make the subject clear. Keep generated intermediates out of version control while retaining the required PDF. Do not place a shared top-level example or asset beside a standalone tutorial if that would give the tutorial multiple root entries.

Verify according to the deliverable:

- Check technical claims against the researched sources and target version. Execute runnable examples where feasible in an appropriate isolated environment; compare observed behaviour with the explanation, including failure or repeat-run behaviour when it is central to the lesson. Do not execute examples against live systems merely to validate the prose.
- For Markdown, check rendering-sensitive syntax, code fences, tables, internal links, and supporting file references with available tools.
- For LaTeX, build through the Makefile, resolve errors and broken references, and inspect the PDF for readability, clipped code, and layout problems. Rebuild after source changes so the committed PDF matches the source.
- Check citations and internal cross-references, and ensure each supporting artifact is reachable from the tutorial.

Report which checks actually ran, their results, and any remaining limits. If a required build or check cannot run, identify the missing prerequisite and leave the deliverable explicitly incomplete rather than claiming verification.

### 6. Review the teaching and deliver

Review the finished tutorial against the learner brief as well as technical correctness. Revise any chapter that:

- Assumes unexplained prerequisites or teaches a misleading mental model.
- Provides code without explaining the consequential behaviour or tradeoff.
- Treats one example architecture as universally correct.
- Gives review questions without showing what adequate evidence looks like.
- Adds complexity without explaining the pressure that justifies it.
- Leaves the learner unable to predict behaviour, assess a proposal, or verify an outcome promised in the outline.

Ensure the progression is coherent, optional advanced material is clearly signposted, and exercises have usable reasoning. Deliver the tutorial with its artifact paths, target version, completed verification, and material limitations. Keep the final handoff concise; the tutorial itself carries the teaching.
