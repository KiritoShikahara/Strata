---
name: task-resume
description: 中断した作業を状態復元して再開 (/pickup)
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - automation
    category: automation
  kiridev:
    namespace: kiridev
    category: automation
    triggers:
    - 再開
    - 続き
    - pickup
    - 前回の続き
    - 中断
    required_tools:
    - terminal
    - todo
    optional_tools:
    - session_search
    - memory
    - read_file
    dependencies:
    - git
    conflicts: []
    workflow: see '## Procedure'
    verification: 実リポジトリ状態と todo が整合し、再開タスクが特定されている
    fallback:
    - 履歴が無い → git reflog / ファイル更新時刻 (Get-ChildItem | Sort LastWriteTime)
    - 不明点は clarify
    risk_level: low
    related:
    - status-reporting
    - checkpoint
    - long-running-task
    - task-prioritization
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# task-resume

中断した作業を状態復元して再開 (/pickup)

## When to Use
Trigger: 再開, 続き, pickup, 前回の続き, 中断

## Tools
- required: terminal, todo
- optional: session_search, memory, read_file
- dependencies: git（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. /pickup または session_search で直近の作業・todo を確認
2. git status; git log -5 --oneline; git diff --stat で実際の状態を把握
3. 記憶と実状態の差分を確認（古い情報を鵜呑みにしない）
4. 未完了項目を todo に再構成し、次の一手から再開
5. 再開点を報告

## Verification
実リポジトリ状態と todo が整合し、再開タスクが特定されている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 履歴が無い → git reflog / ファイル更新時刻 (Get-ChildItem | Sort LastWriteTime)
2. 不明点は clarify

## Related
status-reporting, checkpoint, long-running-task, task-prioritization

## Prohibited
- 記憶だけを根拠に破壊的操作を再実行しない
- 未コミット変更を破棄しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
