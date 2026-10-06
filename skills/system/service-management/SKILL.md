---
name: service-management
description: Windows サービスの状態確認・起動停止・設定
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
    - サービス
    - Get-Service
    - sc.exe
    - 自動起動
    required_tools:
    - terminal
    optional_tools:
    - read_file
    dependencies:
    - powershell
    - sc.exe
    conflicts: []
    workflow: see '## Procedure'
    verification: (Get-Service <name>).Status が Running/Stopped など期待値
    fallback:
    - sc.exe query / sc.exe config を使う
    - net start / net stop を使う
    - services.msc の手動案内
    - NSSM (winget install NSSM.NSSM) でラップ
    risk_level: high
    related:
    - process-management
    - logs-event-viewer
    - permissions-acl
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# service-management

Windows サービスの状態確認・起動停止・設定

## When to Use
Trigger: サービス, Get-Service, sc.exe, 自動起動

## Tools
- required: terminal
- optional: read_file
- dependencies: powershell, sc.exe（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Get-Service <name> | Format-List * で状態と依存を確認する
2. Get-CimInstance Win32_Service -Filter "Name='x'" で実行パスとアカウントを確認する
3. Restart-Service <name> -Verbose で再起動する(管理者権限)
4. Set-Service -Name <n> -StartupType Manual 等は変更前の値を記録してから行う
5. Get-WinEvent -FilterHashtable @{LogName='System'; ProviderName='Service Control Manager'} で失敗理由を見る

## Verification
(Get-Service <name>).Status が Running/Stopped など期待値

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. sc.exe query / sc.exe config を使う
2. net start / net stop を使う
3. services.msc の手動案内
4. NSSM (winget install NSSM.NSSM) でラップ

## Related
process-management, logs-event-viewer, permissions-acl

## Prohibited
- セキュリティ関連サービス(WinDefend, EventLog, RpcSs 等)を停止/無効化しない
- 承認なしで新規サービスを登録しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
