---
name: cron-scheduled-work
description: cronjob / hermes cron で定期・予約タスクを設定
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
    - 定期実行
    - スケジュール
    - cron
    - 毎日
    - 毎朝
    required_tools:
    - cronjob
    - terminal
    optional_tools:
    - read_file
    dependencies:
    - hermes
    conflicts: []
    workflow: see '## Procedure'
    verification: hermes cron list に表示され、試走で期待出力が得られた
    fallback:
    - 'cronjob 不可 → Windows タスクスケジューラ: schtasks /Create /SC DAILY /ST 09:00 /TN name /TR "cmd"'
    - Register-ScheduledTask (PowerShell)
    - WSL の cron
    risk_level: medium
    related:
    - workflow-orchestration
    - status-reporting
    - long-running-task
    - permission-policy
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# cron-scheduled-work

cronjob / hermes cron で定期・予約タスクを設定

## When to Use
Trigger: 定期実行, スケジュール, cron, 毎日, 毎朝

## Tools
- required: cronjob, terminal
- optional: read_file
- dependencies: hermes（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 実行内容・頻度・タイムゾーン(JST)・成功/失敗時の通知先を確認
2. cronjob ツールで登録（CLI なら hermes cron list / hermes cron --help で構文確認）
3. プロンプトは自己完結に書く（前提・パス・完了条件を含める）
4. 初回は手動で1回試走し出力を確認
5. hermes cron list で登録内容と次回実行時刻を確認

## Verification
hermes cron list に表示され、試走で期待出力が得られた

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. cronjob 不可 → Windows タスクスケジューラ: schtasks /Create /SC DAILY /ST 09:00 /TN name /TR "cmd"
2. Register-ScheduledTask (PowerShell)
3. WSL の cron

## Related
workflow-orchestration, status-reporting, long-running-task, permission-policy

## Prohibited
- 外部送信/課金/公開を伴う定期ジョブを承認なしに登録しない
- Secret をプロンプトに直書きしない
- 高頻度ジョブで API 消費を暴走させない
- Approval 対象（permission-policy 参照）は実行前に確認する。
