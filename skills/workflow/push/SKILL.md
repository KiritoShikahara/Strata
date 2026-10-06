---
name: push
description: 現在ブランチを push（force 禁止）
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - workflow
    category: workflow
  kiridev:
    namespace: kiridev
    category: workflow
    triggers:
    - /push
    required_tools:
    - terminal
    optional_tools:
    - delegate_task
    dependencies:
    - git
    conflicts: []
    workflow: see body
    verification: git status で ahead 0
    fallback:
    - fallback Skill（Failure Class 別の代替経路）
    risk_level: medium
    source: ported from qwen-skills/push
---

## Task

First run `git status -sb` (with whatever shell tool is available) to check the branch state.

Push the current branch.

1. If there are no commits ahead of upstream, say so and stop.
2. If the branch has an upstream, run `git push`; otherwise run `git push -u origin <branch>`.
3. Never force-push. If the push is rejected (non-fast-forward), report the error and stop.
4. Report the result in one line (branch and pushed range).
