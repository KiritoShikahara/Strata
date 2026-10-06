---
name: parallel-execution
description: 独立タスクを並列実行して時間短縮する
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
    - 並列
    - 同時実行
    - parallel
    - 並行処理
    required_tools:
    - terminal
    - process
    optional_tools:
    - delegate_task
    dependencies:
    - pwsh
    conflicts: []
    workflow: see '## Procedure'
    verification: 全ジョブの終了状態と出力を収集済みで、逐次実行と結果が一致
    fallback:
    - pwsh 無し → winget install Microsoft.PowerShell / Start-Job
    - 競合発生 → 直列化
    - 重い作業は delegate_task
    risk_level: low
    related:
    - workflow-orchestration
    - subagent-delegation
    - long-running-task
    - git-worktree
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# parallel-execution

独立タスクを並列実行して時間短縮する

## When to Use
Trigger: 並列, 同時実行, parallel, 並行処理

## Tools
- required: terminal, process
- optional: delegate_task
- dependencies: pwsh（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 独立性（共有ファイル/ポート/DB が無い）を確認
2. ツール呼び出しは同一メッセージ内で並列発行、コマンドは PowerShell 7 の ForEach-Object -Parallel -ThrottleLimit 4
3. ジョブ: Start-Job / Wait-Job / Receive-Job（5.1 でも可）
4. リソース上限（CPU/メモリ/API レート）に合わせ並列度を制限
5. 全結果と失敗を収集し集約

## Verification
全ジョブの終了状態と出力を収集済みで、逐次実行と結果が一致

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. pwsh 無し → winget install Microsoft.PowerShell / Start-Job
2. 競合発生 → 直列化
3. 重い作業は delegate_task

## Related
workflow-orchestration, subagent-delegation, long-running-task, git-worktree

## Prohibited
- 同一ファイルへ並列書込しない
- API レート上限・課金を無視した大量並列をしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
