---
name: overnight-autonomy
description: 夜間・不在時に承認不要範囲で自律的に作業を進める
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
    - 夜間
    - 放置
    - 寝てる間
    - overnight
    - 不在
    required_tools:
    - terminal
    - todo
    optional_tools:
    - cronjob
    - delegate_task
    - memory
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: サマリに全タスクの状態があり、変更が git diff / checkpoint で確認できる
    fallback:
    - 行き詰まり → 次タスクへ進み停止理由を記録
    - ツール不能 → fallback の代替経路
    - 継続不可 → 状態を保存して安全に停止
    risk_level: high
    related:
    - goal-driven-autonomy
    - checkpoint
    - rollback
    - status-reporting
    - task-resume
    - permission-policy
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# overnight-autonomy

夜間・不在時に承認不要範囲で自律的に作業を進める

## When to Use
Trigger: 夜間, 放置, 寝てる間, overnight, 不在

## Tools
- required: terminal, todo
- optional: cronjob, delegate_task, memory
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. /overnight で開始。作業リストを todo に作り優先度順 (task-prioritization) に並べる
2. 承認が必要な項目は実行せず「朝の確認事項」に積む（permission-policy）
3. 各タスク前に checkpoint を作成し、失敗時は failure-recovery / rollback
4. 進捗とログを定期的にファイルへ書き出す (status-reporting)
5. 終了時に完了/未完/要承認のサマリを作成。再開用に task-resume 情報を残す

## Verification
サマリに全タスクの状態があり、変更が git diff / checkpoint で確認できる

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 行き詰まり → 次タスクへ進み停止理由を記録
2. ツール不能 → fallback の代替経路
3. 継続不可 → 状態を保存して安全に停止

## Related
goal-driven-autonomy, checkpoint, rollback, status-reporting, task-resume, permission-policy

## Prohibited
- 承認対象（大量削除/外部送信/公開/課金/システム設定）を無人で実行しない
- force push・本番変更をしない
- Secret を出力しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
