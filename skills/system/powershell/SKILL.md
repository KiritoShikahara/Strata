---
name: powershell
description: PowerShell 5.1/7 のコマンド実行とパイプライン処理
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
    - PowerShell
    - pwsh
    - Get-
    - Set-
    - ps1
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - execute_code
    dependencies:
    - pwsh
    conflicts: []
    workflow: see '## Procedure'
    verification: $LASTEXITCODE と $? が成功値、期待オブジェクトが出力されること
    fallback:
    - 'pwsh 不在: winget install Microsoft.PowerShell'
    - powershell.exe(5.1) で互換構文に書換える
    - cmd /c でバッチ等価コマンドを使う
    - Python (subprocess) で代替実装
    risk_level: medium
    related:
    - cmd
    - powershell-scripting
    - filesystem
    - debugging
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# powershell

PowerShell 5.1/7 のコマンド実行とパイプライン処理

## When to Use
Trigger: PowerShell, pwsh, Get-, Set-, ps1

## Tools
- required: terminal, read_file
- optional: execute_code
- dependencies: pwsh（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. $PSVersionTable.PSVersion で 5.1 か 7 かを確認する
2. Get-Command <cmd>; Get-Help <cmd> -Examples で構文を確認する
3. パイプラインは Where-Object / Select-Object / Sort-Object で絞り、-WhatIf 対応コマンドは先に -WhatIf で実行する
4. $ErrorActionPreference = "Stop" と try/catch で失敗を検知する
5. 出力は ConvertTo-Json -Depth 5 や Export-Csv で構造化する

## Verification
$LASTEXITCODE と $? が成功値、期待オブジェクトが出力されること

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. pwsh 不在: winget install Microsoft.PowerShell
2. powershell.exe(5.1) で互換構文に書換える
3. cmd /c でバッチ等価コマンドを使う
4. Python (subprocess) で代替実装

## Related
cmd, powershell-scripting, filesystem, debugging

## Prohibited
- Invoke-Expression で外部入力を実行しない
- Remove-Item -Recurse -Force を確認なしで広範囲に使わない
- ExecutionPolicy を恒久的に Unrestricted にしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
