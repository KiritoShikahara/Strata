---
name: checkpoint
description: 作業状態を .kiridev/checkpoint.md と git/snapshot に保存
version: 1.0.0
metadata:
  hermes:
    tags: [kiridev, workflow, automation]
    category: workflow
  kiridev:
    namespace: kiridev
    category: workflow
    triggers: [/checkpoint, 区切り, 長時間作業の途中, 危険な変更の前]
    required_tools: [terminal, write_file]
    optional_tools: []
    dependencies: [git]
    conflicts: []
    workflow: see '## Procedure'
    verification: checkpoint.md が更新され、git stash/commit または /snapshot ID が記録されている
    fallback: [git が無い → フォルダを .kiridev/backup/<時刻>/ にコピー]
    risk_level: low
    source: hand-written
---

# checkpoint

Hermes には filesystem checkpoint（`/rollback`、`/snapshot`）がある。KiriDev はそれに **作業状態のメモ** を足す。

## Procedure
1. `.kiridev/checkpoint.md` を上書き（無ければ作成。`.kiridev/` は .gitignore 推奨）:
   ```
   # Checkpoint <YYYY-MM-DD HH:MM> / <branch>
   Goal: / Done: / Next: / Open problems: / Build: PASS|FAIL / Test: PASS|FAIL
   Restore: git stash@{n} | commit <sha> | /rollback <n>
   ```
2. コード状態の保存（どれか 1 つ）:
   - コミット可能な単位なら WIP コミット（`git commit -m "wip: <要約>"`。push はしない）
   - コミットしたくなければ `git stash push -u -m "kiridev-checkpoint <時刻>"` → 直後に `git stash apply`（作業は継続）
   - Hermes CLI なら `/snapshot create` をユーザーに提案
3. `kdlog.py event checkpoint <project> --detail "<sha or stash>"`。

## Restore（rollback）
`/rollback`（Hermes filesystem checkpoints）、`git stash apply`、`git reset --soft <sha>`。`--hard` は Approval 対象。
