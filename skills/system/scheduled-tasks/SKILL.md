---
name: scheduled-tasks
description: タスクスケジューラの作成・確認・削除
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - system
    category: system
  kiridev:
    namespace: kiridev
    category: system
    triggers:
    - タスクスケジューラ
    - 定期実行
    - schtasks
    - 自動実行
    required_tools:
    - terminal
    optional_tools:
    - cronjob
    dependencies:
    - schtasks
    conflicts: []
    workflow: see '## Procedure'
    verification: (Get-ScheduledTaskInfo <n>).LastTaskResult -eq 0
    fallback:
    - schtasks /create /tn <n> /tr <cmd> /sc daily に切替
    - Hermes cronjob ツールで代替
    - 'ログ確認: Microsoft-Windows-TaskScheduler/Operational'
    risk_level: medium
    related:
    - powershell
    - logs-event-viewer
    - permission-policy
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# scheduled-tasks

タスクスケジューラの作成・確認・削除

## When to Use
Trigger: タスクスケジューラ, 定期実行, schtasks, 自動実行

## Tools
- required: terminal
- optional: cronjob
- dependencies: schtasks（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Get-ScheduledTask -TaskPath "\" | Get-ScheduledTaskInfo で既存を確認する
2. New-ScheduledTaskAction -Execute pwsh.exe -Argument "-NoProfile -File <script>" を定義する
3. New-ScheduledTaskTrigger -Daily -At 03:00 と Register-ScheduledTask -TaskName <n> で登録する
4. Start-ScheduledTask 後に LastTaskResult が 0 であることを確認する
5. 登録内容は Export-ScheduledTask で XML 保存する

## Verification
(Get-ScheduledTaskInfo <n>).LastTaskResult -eq 0

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. schtasks /create /tn <n> /tr <cmd> /sc daily に切替
2. Hermes cronjob ツールで代替
3. ログ確認: Microsoft-Windows-TaskScheduler/Operational

## Related
powershell, logs-event-viewer, permission-policy

## Prohibited
- SYSTEM/最上位権限での登録を承認なしで行わない
- 既存タスクの削除/上書きを承認なしで行わない
- 起動時自動実行の永続化を黙って追加しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
