---
name: commit
description: "Stage all changes and commit with a concise conventional-commit message matching repo history."
argument-hint: "[optional message or hint]"
---

## Task

First run `git status -sb`, `git diff HEAD --stat` and `git log --oneline -5` (with whatever shell tool is available) to gather context.

Commit all current changes (tracked and untracked) in one commit.

1. If there are no changes, say so and stop.
2. Inspect `git diff HEAD` as needed to understand the change.
3. Do not stage files that look like secrets (`.env`, credentials, keys); mention any skipped.
4. Write a one-line message in the same style/language as recent commits (e.g. `feat: ...`, `fix: ...`, `chore: ...`). If `$ARGUMENTS` is given, use it as the message or as a hint.
5. `git add -A` (minus skipped files) and `git commit -m "<message>"`.
6. Report the short hash and message in one line. Do not push.
