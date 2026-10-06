---
name: workflow-orchestration
description: 複数ステップの作業を依存関係付きで設計・実行・追跡
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
    - ワークフロー
    - パイプライン
    - 段取り
    - オーケストレーション
    required_tools:
    - terminal
    - todo
    optional_tools:
    - delegate_task
    - cronjob
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 全工程の完了条件を満たす実行ログがあり、todo が全て完了
    fallback:
    - 複雑化 → 工程を縮小して直列実行
    - 'スクリプト化: PowerShell .ps1 に工程を関数化'
    risk_level: low
    related:
    - parallel-execution
    - task-prioritization
    - failure-recovery
    - cron-scheduled-work
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# workflow-orchestration

複数ステップの作業を依存関係付きで設計・実行・追跡

## When to Use
Trigger: ワークフロー, パイプライン, 段取り, オーケストレーション

## Tools
- required: terminal, todo
- optional: delegate_task, cronjob
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 工程を列挙し入出力・依存・失敗時動作・検証点を定義
2. todo に登録し、各工程の完了条件を実コマンドで定義
3. 工程ごとに checkpoint を置き順に実行、独立工程は parallel-execution
4. 失敗工程は failure-recovery、再実行は冪等に
5. 全体結果を status-reporting で報告

## Verification
全工程の完了条件を満たす実行ログがあり、todo が全て完了

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 複雑化 → 工程を縮小して直列実行
2. スクリプト化: PowerShell .ps1 に工程を関数化

## Related
parallel-execution, task-prioritization, failure-recovery, cron-scheduled-work

## Prohibited
- 承認が必要な工程を自動で進めない
- 依存を無視して並列化しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
