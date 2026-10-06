---
name: environment-variables
description: 環境変数と PATH の確認・設定
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
    - 環境変数
    - PATH
    - setx
    - $env
    required_tools:
    - terminal
    optional_tools: []
    dependencies:
    - powershell
    conflicts: []
    workflow: see '## Procedure'
    verification: Get-Command <exe> が新 PATH で解決され、新規 pwsh で値が見える
    fallback:
    - 'セッション限定: $env:NAME = value'
    - システムプロパティ(sysdm.cpl)の手動案内
    - プロファイル($PROFILE)で設定
    risk_level: medium
    related:
    - registry
    - powershell
    - package-management
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# environment-variables

環境変数と PATH の確認・設定

## When to Use
Trigger: 環境変数, PATH, setx, $env

## Tools
- required: terminal
- optional: -
- dependencies: powershell（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. $env:PATH -split ";" で現在のプロセス PATH を確認する
2. [Environment]::GetEnvironmentVariable("PATH","User") でユーザー値を確認する
3. 現在値を退避してから [Environment]::SetEnvironmentVariable(name,value,"User") で設定する
4. setx は 1024 文字で切れるため PATH には使わない
5. 新しいシェルを開いて反映を確認する

## Verification
Get-Command <exe> が新 PATH で解決され、新規 pwsh で値が見える

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. セッション限定: $env:NAME = value
2. システムプロパティ(sysdm.cpl)の手動案内
3. プロファイル($PROFILE)で設定

## Related
registry, powershell, package-management

## Prohibited
- Machine スコープを承認なしで変更しない
- API キー等の値をログ/出力に表示しない
- PATH を丸ごと上書きしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
