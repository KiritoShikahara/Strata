---
name: compus
description: commit してから push（/commit + /push）
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
    - /compus
    required_tools:
    - terminal
    optional_tools:
    - delegate_task
    dependencies:
    - git
    conflicts: []
    workflow: see body
    verification: commit hash と push 結果
    fallback:
    - fallback Skill（Failure Class 別の代替経路）
    risk_level: medium
    source: ported from qwen-skills/compus
---

## Task

First run `git status -sb`, `git diff HEAD --stat` and `git log --oneline -5` (with whatever shell tool is available) to gather context.

1. **Commit** (skip if the working tree is clean):
   - Inspect `git diff HEAD` as needed.
   - Do not stage files that look like secrets (`.env`, credentials, keys); mention any skipped.
   - One-line message in the same style/language as recent commits. If `（コマンド引数）` is given, use it as the message or as a hint.
   - `git add -A` (minus skipped files) and `git commit -m "<message>"`.
2. **Push**:
   - If nothing is ahead of upstream, say so and stop.
   - `git push` if upstream exists, otherwise `git push -u origin <branch>`.
   - Never force-push. If rejected, report the error and stop.
3. Report in one or two lines: commit hash + message, and push result.
