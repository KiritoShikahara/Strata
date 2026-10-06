---
name: logs-event-viewer
description: イベントログとアプリログの調査
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
    - イベントログ
    - Get-WinEvent
    - ログ調査
    - エラー原因
    required_tools:
    - terminal
    - search_files
    optional_tools:
    - read_file
    dependencies:
    - powershell
    - wevtutil
    conflicts: []
    workflow: see '## Procedure'
    verification: 事象時刻に対応するイベント ID と原因候補を提示
    fallback:
    - Get-EventLog (5.1) に切替
    - wevtutil qe System /c:20 /rd:true /f:text
    - Security ログは管理者権限が必要→昇格を依頼
    - アプリ側ログは Select-String で検索
    risk_level: low
    related:
    - debugging
    - service-management
    - system-monitoring
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# logs-event-viewer

イベントログとアプリログの調査

## When to Use
Trigger: イベントログ, Get-WinEvent, ログ調査, エラー原因

## Tools
- required: terminal, search_files
- optional: read_file
- dependencies: powershell, wevtutil（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Get-WinEvent -ListLog * | Where RecordCount で有効ログを確認する
2. Get-WinEvent -FilterHashtable @{LogName='Application','System'; Level=1,2; StartTime=(Get-Date).AddHours(-6)}
3. ProviderName / Id で絞り Message を Select-Object -First 20 で確認する
4. 時刻をユーザーの事象と突合し前後イベントを確認する
5. wevtutil epl System <file>.evtx で証跡を保存する

## Verification
事象時刻に対応するイベント ID と原因候補を提示

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. Get-EventLog (5.1) に切替
2. wevtutil qe System /c:20 /rd:true /f:text
3. Security ログは管理者権限が必要→昇格を依頼
4. アプリ側ログは Select-String で検索

## Related
debugging, service-management, system-monitoring

## Prohibited
- wevtutil cl 等でログを消去しない
- ログ内の個人情報/Secret を外部送信しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
