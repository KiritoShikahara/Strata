---
name: process-management
description: プロセスの一覧・監視・起動・停止
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
    - プロセス
    - kill
    - タスクマネージャ
    - 起動中
    - ハング
    required_tools:
    - terminal
    - process
    optional_tools: []
    dependencies:
    - powershell
    conflicts: []
    workflow: see '## Procedure'
    verification: Get-Process -Id <pid> が見つからない、または期待プロセスが Responding=True
    fallback:
    - 'Stop-Process 拒否: taskkill /PID <pid> /T'
    - '権限不足: 昇格を依頼'
    - Sysinternals Process Explorer (winget install Microsoft.Sysinternals.ProcessExplorer)
    risk_level: medium
    related:
    - service-management
    - system-monitoring
    - powershell
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# process-management

プロセスの一覧・監視・起動・停止

## When to Use
Trigger: プロセス, kill, タスクマネージャ, 起動中, ハング

## Tools
- required: terminal, process
- optional: -
- dependencies: powershell（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Get-Process | Sort-Object CPU -Descending | Select -First 10 で負荷を確認する
2. Get-CimInstance Win32_Process -Filter "Name='x.exe'" で CommandLine と親 PID を確認する
3. Get-NetTCPConnection -OwningProcess <pid> でポート使用を確認する
4. まず CloseMainWindow() で正常終了を試し、駄目なら Stop-Process -Id <pid>
5. 起動は Start-Process -PassThru で PID を記録する

## Verification
Get-Process -Id <pid> が見つからない、または期待プロセスが Responding=True

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. Stop-Process 拒否: taskkill /PID <pid> /T
2. 権限不足: 昇格を依頼
3. Sysinternals Process Explorer (winget install Microsoft.Sysinternals.ProcessExplorer)

## Related
service-management, system-monitoring, powershell

## Prohibited
- システムプロセス(csrss/lsass/winlogon 等)を停止しない
- 対象 PID を確認せず名前一括 kill しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
