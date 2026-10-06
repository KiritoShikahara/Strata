---
name: long-running-task
description: 長時間処理をバックグラウンド実行し監視・再開可能にする
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
    - 長時間
    - バックグラウンド
    - 時間がかかる
    - ビルド待ち
    required_tools:
    - terminal
    - process
    optional_tools:
    - cronjob
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: プロセス終了、exit code 0、ログ末尾に完了表示、成果物存在
    fallback:
    - ハング → 出力停止時間で判定し再起動
    - セッション断絶対策 → Start-Process -WindowStyle Hidden / タスクスケジューラ
    - WSL の tmux / nohup
    risk_level: low
    related:
    - status-reporting
    - task-resume
    - failure-recovery
    - cron-scheduled-work
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# long-running-task

長時間処理をバックグラウンド実行し監視・再開可能にする

## When to Use
Trigger: 長時間, バックグラウンド, 時間がかかる, ビルド待ち

## Tools
- required: terminal, process
- optional: cronjob
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. process / terminal のバックグラウンド実行で起動し、出力をログへ: cmd *> $env:TEMP\job.log
2. PID・開始時刻・ログパスを記録 (Get-Process -Id)
3. 定期的に Get-Content job.log -Tail 20 で進捗を確認（sleep 連打を避ける）
4. タイムアウトと再実行可能性（冪等・途中再開）を設計
5. 完了後に exit code と成果物を検証

## Verification
プロセス終了、exit code 0、ログ末尾に完了表示、成果物存在

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. ハング → 出力停止時間で判定し再起動
2. セッション断絶対策 → Start-Process -WindowStyle Hidden / タスクスケジューラ
3. WSL の tmux / nohup

## Related
status-reporting, task-resume, failure-recovery, cron-scheduled-work

## Prohibited
- 孤児プロセスを残さない
- 他ユーザー/無関係プロセスを kill しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
