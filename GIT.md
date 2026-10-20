# GIT.md

Read this before any git or gh operation in this repository.

## Local operations

- Run git against this checkout only. Never `cd` into another worktree
  or clone to run git there, and never chain `cd <dir> && git ...`: if
  the `cd` lands somewhere unexpected, the command silently acts on the
  wrong branch. Use `git -C <dir>` when another checkout really is the
  target.
- As soon as you create a file, run `git add --intent-to-add` on it,
  so `git status` and `git diff` show it to you and to any reviewer.
- Ask before committing. You may commit without asking only when the
  user's request includes committing, e.g. a multi-step task with
  commits along the way. Your commits go through the same checks and
  review as anyone else's (see `AGENTS.md`).
- Each commit is one logical change. Do not combine two tutorials, or a
  tutorial and a meta-file change, in one commit.
- Destructive operations need the user's explicit go-ahead each time:
  `reset --hard`, rebases or other history rewrites, amending a commit
  that has been pushed, and deleting branches.

## GitHub and pushing

git and GitHub are different tools. Do work locally, and touch GitHub
(`git push`, `gh`) only when the user's prompt explicitly asks for it,
or after you ask and they agree. Prefer local equivalents: if asked to
merge, use `git merge --ff-only`, not `gh pr merge`.

Never run `git push` in any form unless explicitly asked. A push after
a history rewrite is a force-push and needs explicit approval every
time, because approval for one push does not carry over to the next.
An authorised force-push is always `git push --force-with-lease`, never
`--force` or `-f`.

## Commit messages

Follow the "Commit messages" section of `~/src/jma/AI/jeff-doctor.md`,
which is the source of truth; do not keep a copy here. If that file is
unavailable, say so and ask before committing. In particular:

- Draft multi-line messages with a heredoc or `git commit -F`, never
  with literal `\n` in `-m`.
- Check the subject (~50 chars) and body wrap (~72 chars) in the draft
  before proposing it, not after committing.
- This repository is young, so a number in a branch name is quite
  plausibly an issue number. Check that the issue exists with the user
  before citing it.

Confirm aloud that you have read GIT.md.
