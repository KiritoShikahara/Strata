---
name: push
description: "Push the current branch to its upstream (sets upstream to origin if missing)."
---

## Task

First run `git status -sb` (with whatever shell tool is available) to check the branch state.

Push the current branch.

1. If there are no commits ahead of upstream, say so and stop.
2. If the branch has an upstream, run `git push`; otherwise run `git push -u origin <branch>`.
3. Never force-push. If the push is rejected (non-fast-forward), report the error and stop.
4. Report the result in one line (branch and pushed range).
