---
name: commit
description: 全変更を履歴の書式に合わせて 1 コミット
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
    - /commit
    - コミットして
    required_tools:
    - terminal
    optional_tools:
    - delegate_task
    dependencies:
    - git
    conflicts: []
    workflow: see body
    verification: git log -1 に新コミット、git status clean
    fallback:
    - fallback Skill（Failure Class 別の代替経路）
    risk_level: low
    source: ported from qwen-skills/commit
---

## Task

First run `git status -sb`, `git diff HEAD --stat` and `git log --oneline -5` (with whatever shell tool is available) to gather context.

Commit all current changes (tracked and untracked) in one commit.

1. If there are no changes, say so and stop.
2. Inspect `git diff HEAD` as needed to understand the change.
3. Do not stage files that look like secrets (`.env`, credentials, keys); mention any skipped.
4. Write a one-line message in the same style/language as recent commits (e.g. `feat: ...`, `fix: ...`, `chore: ...`). If `（コマンド引数）` is given, use it as the message or as a hint.
5. `git add -A` (minus skipped files) and `git commit -m "<message>"`.
6. Report the short hash and message in one line. Do not push.
