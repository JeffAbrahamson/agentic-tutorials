This file contains notes from a conversation with chatgpt.  Your job here is to draft the skll. Capture the learner’s role, the interview process, the teaching principles, the generation workflow, and the quality criteria.  Distil this file into operational instructions, rather than preserving the conversation itself.

I wrote:

I want to write a skill to generate a tutorial.  Today, it is about ansible, but I'm interested just now in the general instructions / prompt for doing so.  The point of generating it using AI is to target the tutorial to me and my needs.  In particular, where once I read a tutorial so that I could write code, now I generally read a tutorial so that I can collaborate on code with an LLM agent.  So my needs are different, and few tutorials on the web target this.

I think what I want is the following:

- start from fundamentals and proceed through to advanced
- show code samples to illustrate, but understand that I don't plan to write much code
- i probably want to understand something about the tools execution model and how it works
- on the other hand, i need to understand patterns and best practice, how to work with simple examples but also how to manage complex systems built with the tool
- i also need to understand what are anti-patterns and ways that users of the tool trip up

What else should I want in this skill?

---

chatgpt wrote:

The central distinction is that you want **the understanding needed to direct, question, and review an implementation**, rather than the fluency needed to type it yourself. Those overlap, but they produce quite different tutorials.

Your list already covers much of that. I would add the following requirements.

**1. Explain the tool’s boundaries and tradeoffs.**  
What problem does it solve? When is it a good fit, when is it unnecessary, and when should another tool own part of the problem? Include what it cannot guarantee. Otherwise, you can become good at discussing a tool without knowing whether the agent should be using it.

**2. Teach a predictive mental model.**  
“Explain the execution model” is particularly important. Make the requirement stronger: after a section, you should be able to predict what a small example will do—and explain why. Cover where execution happens, how state is represented, ordering, scope, dependencies, failure, and retries, wherever applicable.

For Ansible, for example, “this describes the desired state” is insufficient unless you also understand the sequence of tasks, which machine executes what, and what happens after a partial failure.

**3. Make design decisions explicit.**  
A tutorial should distinguish:

| Kind of decision | What you need to learn |
|---|---|
| Mechanical detail | Something you can usually delegate |
| Established convention | Something the agent should normally follow |
| Architectural choice | Something you need to discuss and approve |
| Context-dependent tradeoff | Something requiring evidence about your system |

For consequential choices, show alternatives and explain what circumstances favour each. Avoid presenting one worked example as the universally correct architecture.

**4. Teach verification as a first-class activity.**  
How do you establish that the generated implementation is correct? Cover what you can inspect, what you can test, what a dry run actually establishes, and what still requires observation in a realistic environment.

Include cases where an implementation runs successfully but is still wrong: it changes the wrong thing, hides drift, exposes secrets, or cannot safely be run again. **Successful execution is evidence, not a complete acceptance criterion.**

**5. Include how to interrogate an agent’s proposal.**  
Each substantial topic should give you useful review questions, the evidence a good answer should contain, and warning signs in a weak answer. For example:

- What assumptions does this design make about the existing system?
- What happens if execution stops halfway through?
- What happens on the second run?
- How would we detect that the result is wrong?
- Which parts depend on the installed version?

This should teach substantive scrutiny, rather than stock prompts such as “check your work.”

**6. Cover diagnosis and recovery alongside construction.**  
Show characteristic symptoms, the underlying causes, and how to distinguish competing explanations. Teach which logs, outputs, or state to inspect before accepting a proposed fix. Include recovery from partial completion and the limits of rollback.

That matters when collaborating with an agent: you need to recognise when it is investigating a failure and when it is repeatedly modifying code without a supported diagnosis.

**7. Show the transition from a small example to a maintained system.**  
Don’t merely follow a toy example with a large directory tree. Explain the pressures that justify adding structure: multiple environments, ownership boundaries, reuse, secrets, testing, dependencies, and operational constraints.

Also cover how to modify an existing system. Much of your real work will involve understanding inherited conventions and making bounded changes, rather than starting from an empty repository.

**8. Identify plausible mistakes an LLM might produce.**  
Alongside ordinary antipatterns, ask for examples of implementations that look convincing but contain faulty assumptions, obsolete interfaces, unnecessary abstraction, or inappropriate defaults. These should be grounded in the tool’s actual behaviour, with explanations and verification methods—not speculative claims about what models “always” do.

**9. Use exercises that match your role.**  
Prefer exercises such as:

- Predict the behaviour of a short example.
- Review a proposed change and identify its risks.
- Choose between two designs under stated constraints.
- Diagnose a failure from its output.
- Write acceptance criteria for an agent’s implementation.

Writing small amounts of code can still be useful, but it should serve understanding rather than become the default measure of progress.

**10. Adapt to your knowledge and intended work.**  
The skill should establish what you already understand, what you intend to build or maintain, and what decisions you expect to retain. It should use familiar concepts as bridges while explicitly identifying where analogies break down.

For you, an Ansible tutorial could build on SaltStack and your deployment experience. It should not spend pages explaining why configuration management exists, but it should investigate which Salt assumptions transfer poorly.

I would also qualify **“fundamentals through advanced.”** That can encourage an encyclopaedic march through features. A better progression is *fundamentals → routine work → system design → failure and recovery → advanced topics relevant to your use*. Put specialised features in optional branches, with clear reasons to read them.

The guiding instruction could be:

> Optimise the tutorial for the learner’s ability to explain behaviour, make design decisions, specify work, review generated implementations, and verify outcomes. Use code to make those abilities concrete. Do not equate completeness with exhaustive feature coverage, or competence with memorising syntax.

And one particularly useful recurring device would be: **“What can I now judge that I could not judge before?”** Each chapter should have a concrete answer.

---

Some further notes from chatgpt:

Interview → save the brief → establish an outline → research → write → verify → review.

A few details deserve particular care:
- Give the interview a stopping condition. Ask questions whose answers materially change scope, depth, examples, or presentation. Avoid an indefinite requirements interview.
- Separate personalisation from the reusable skill. Your SaltStack experience belongs in the learner brief; the instruction to discover relevant prior knowledge belongs in the skill.
- Require authoritative, version-specific research. Explain how to handle unavailable browsing and uncertainty.
- Define verification by output format. Check examples where feasible; compile LaTeX; check references and internal links. Report which checks actually ran.
- Review the teaching as well as the code. A technically valid example can still teach the wrong mental model or omit the consequential tradeoff.
- Preserve explanations. “I won’t write much code” must not become an excuse to substitute checklists and management advice for technical understanding.

---

I add:

  * Decide yourself if there is an advantage of using LaTeX vs markdown for the tutorial.
  * Either way, present your reasoned opinion and ask me at the end of the interview to confirm that I agree.
  * If you decide on LaTeX, create the tutorial in a subdir and include a Makefile that compiles to pdf.  The pdf should commit with the tutorial.
  * If the markdown is stand-alone, it doesn't need a subdir, but if it contains supporting files, it should get a subdir.
  * The intent is one root-level entry per tutorial.
