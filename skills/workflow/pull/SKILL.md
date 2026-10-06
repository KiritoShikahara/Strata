---
name: pull
description: 現在ブランチを fast-forward のみで更新
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
    - /pull
    - 最新を取得
    required_tools:
    - terminal
    optional_tools:
    - delegate_task
    dependencies:
    - git
    conflicts: []
    workflow: see body
    verification: git status で behind 0
    fallback:
    - fallback Skill（Failure Class 別の代替経路）
    risk_level: low
    source: ported from qwen-skills/pull
---

## Task

First run `git status -sb` and `git fetch --prune` (with whatever shell tool is available).

Bring the current branch up to date with GitHub.

1. If the branch has no upstream, report that and stop.
2. If it is already up to date (not behind), say so and stop.
3. If it is behind and not ahead, run `git pull --ff-only`. Uncommitted changes are fine as long as git does not refuse; if git refuses because local edits would be overwritten, report the conflicting files and stop. Never stash, reset, or discard local changes.
4. If it has diverged (both ahead and behind), do not merge or rebase. Report the ahead/behind counts and stop.
5. Report in one or two lines: the updated range (`old..new`) and the number of new commits with their one-line subjects (max 5), plus any uncommitted local changes still present.
