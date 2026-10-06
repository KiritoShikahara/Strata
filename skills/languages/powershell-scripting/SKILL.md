---
name: powershell-scripting
description: 再利用可能な PowerShell スクリプト/モジュールの作成
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - languages
    category: languages
  kiridev:
    namespace: kiridev
    category: languages
    triggers:
    - ps1
    - PowerShell スクリプト
    - 関数
    - モジュール
    - Pester
    required_tools:
    - terminal
    - read_file
    - write_file
    optional_tools:
    - patch
    dependencies:
    - pwsh
    - Pester
    - PSScriptAnalyzer
    conflicts: []
    workflow: see '## Procedure'
    verification: Invoke-ScriptAnalyzer 指摘 0、Invoke-Pester 成功
    fallback:
    - 'Pester 不在: Install-Module Pester -Scope CurrentUser'
    - 'PSScriptAnalyzer 不在: Install-Module PSScriptAnalyzer -Scope CurrentUser'
    - 5.1 互換でない構文は pwsh 7 を使う
    - Python スクリプトで代替
    risk_level: low
    related:
    - powershell
    - testing
    - filesystem
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# powershell-scripting

再利用可能な PowerShell スクリプト/モジュールの作成

## When to Use
Trigger: ps1, PowerShell スクリプト, 関数, モジュール, Pester

## Tools
- required: terminal, read_file, write_file
- optional: patch
- dependencies: pwsh, Pester, PSScriptAnalyzer（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Set-StrictMode -Version Latest と $ErrorActionPreference = "Stop" を先頭に置く
2. [CmdletBinding(SupportsShouldProcess)] と param() で型付き引数、-WhatIf/-Confirm 対応にする
3. 外部コマンド後は $LASTEXITCODE を確認する
4. Invoke-ScriptAnalyzer -Path . で静的検査する
5. Invoke-Pester で単体テストを実行する

## Verification
Invoke-ScriptAnalyzer 指摘 0、Invoke-Pester 成功

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. Pester 不在: Install-Module Pester -Scope CurrentUser
2. PSScriptAnalyzer 不在: Install-Module PSScriptAnalyzer -Scope CurrentUser
3. 5.1 互換でない構文は pwsh 7 を使う
4. Python スクリプトで代替

## Related
powershell, testing, filesystem

## Prohibited
- Invoke-Expression で外部入力を実行しない
- 資格情報を平文で埋め込まない
- 破壊的処理を -WhatIf 対応なしで書かない
- Approval 対象（permission-policy 参照）は実行前に確認する。
