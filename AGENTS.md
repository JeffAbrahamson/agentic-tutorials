# AGENTS.md

This repository accumulates tutorials written with the skill in
`SKILL.md`. Each tutorial is personalised for a learner who directs,
questions, and reviews work implemented by an LLM agent.

When doing any git or gh operation, you must first read and understand
`GIT.md`.

## Layout

- Repository meta files have upper-case names: `AGENTS.md`, `CLAUDE.md`,
  `GIT.md`, `README.md`, `LICENSE`, `SKILL.md`, plus `.gitignore`.
- Every other root entry is one tutorial: either a standalone Markdown
  file or a subdirectory. `SKILL.md` ("Package and verify") defines what
  goes in each. Use a lower-case, subject-revealing name (`ansible.md`,
  `ansible/`) so tutorials are never confused with meta files.
- Never add a shared top-level example or asset; it would give a
  tutorial a second root entry.

## Working on tutorials

- To write or revise a tutorial, read `SKILL.md` in full and follow it.
  For an existing tutorial, read its learner brief and content first.
- Do not edit `SKILL.md` unless the task is specifically about changing
  the skill. Changes to it are tasks in their own right, not side
  effects of writing a tutorial. If a tutorial exposes a problem in the
  skill, say so and propose the change instead.
- Do not touch other tutorials while working on one.
- Write in British English (en-UK). A tutorial's learner brief may ask
  for another convention in that tutorial's text; commit messages stay
  en-UK regardless.
- Do not make whitespace or formatting changes unrelated to the task.

## Checks

Run these without asking before proposing a commit, and never commit
with a failing check:

```sh
git diff --check HEAD   # trailing whitespace, conflict markers
make -C TUTORIAL_DIR    # each touched LaTeX tutorial builds
```

For a LaTeX tutorial, make sure the committed PDF was rebuilt from the
committed source. There is no automated Markdown check: pandoc and
similar tools accept broken fences, tables, and links without
complaint, so inspect them as `SKILL.md` ("Package and verify")
requires. These checks are repository hygiene. They do not replace the
verification `SKILL.md` requires of a tutorial's content.
If you cannot run a check, say which one and why, and ask the user to
run it rather than reporting success.

## Subagents

Delegate when a subtask would pull a lot of throwaway material into
the main context. The typical case is reading through documentation,
release notes, and upstream examples for a tutorial, where you need the
conclusions and source links but not the pages. A cheaper model suits
narrow, well-specified lookups. Do everything else inline. Spawning
costs time and loses shared context, so a single file read or a quick
check does not justify a subagent.

## Review

Before proposing a commit or handing off a non-trivial change, get one
independent review from a fresh subagent (or `/code-review`). Trivial
changes are exempt: typo fixes and one-line wording tweaks. Treat
anything ambiguous as non-trivial. The rule applies equally to your own
work, to work from another session, and to anything you are asked to
review.

- Say when the review starts and that you are waiting for it. Count
  each launch out loud ("launching the first review subagent"). Report
  what it found and how you addressed each point.
- One review is normally enough here. Launch another only when
  substantial doubt remains after fixing its findings. If you reach a
  third round, suspect a deeper problem and ask the user.
- For a tutorial, the reviewer checks technical claims against the
  cited sources and the target version, and checks the teaching against
  the learner brief. For meta files, it checks consistency with this
  file and `SKILL.md`.
- Brief the reviewer to stay read-only and limit itself to the diff,
  plus whatever context it needs to confirm a suspected issue. Each
  finding should cite file and line, state the condition and impact
  ("this misleads the reader about X because Y"), and be ranked by
  severity. It should not report pre-existing issues, issues on lines
  the change didn't touch, or nitpicks a careful senior engineer would
  not raise. If it finds nothing, it should say so.
- Weigh review feedback, whether from a subagent or a human, on its
  merits. If you disagree with a point, say so and explain why rather
  than silently complying or ignoring it.

Confirm aloud that you have read AGENTS.md.
