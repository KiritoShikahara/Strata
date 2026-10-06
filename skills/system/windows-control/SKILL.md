---
name: windows-control
description: Windows 11 の設定・ウィンドウ・アプリ操作を自動化する
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
    - Windows 操作
    - ウィンドウ
    - 設定変更
    - アプリ起動
    required_tools:
    - terminal
    - computer_use
    optional_tools:
    - vision_analyze
    - browser_vision
    dependencies:
    - powershell
    conflicts: []
    workflow: see '## Procedure'
    verification: Get-Process <name> や Get-ItemProperty で期待状態になっていることを確認
    fallback:
    - 'ms-settings: URI や COM(WScript.Shell) 経由に切替'
    - UI Automation (System.Windows.Automation) を使う
    - computer_use による画面操作に切替
    - AutoHotkey を winget install AutoHotkey.AutoHotkey で導入
    risk_level: medium
    related:
    - powershell
    - registry
    - permission-policy
    - verification
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# windows-control

Windows 11 の設定・ウィンドウ・アプリ操作を自動化する

## When to Use
Trigger: Windows 操作, ウィンドウ, 設定変更, アプリ起動

## Tools
- required: terminal, computer_use
- optional: vision_analyze, browser_vision
- dependencies: powershell（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Get-Process | Where-Object MainWindowTitle で対象ウィンドウを特定する
2. Start-Process / ms-settings:<page> URI で設定アプリやアプリを起動する
3. UI 操作が必要なら computer_use でスクリーンショットを取り座標/要素を確認して操作する
4. 変更前に Get-ItemProperty 等で現在値を記録する
5. 操作後に再度状態を取得して差分を確認する

## Verification
Get-Process <name> や Get-ItemProperty で期待状態になっていることを確認

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. ms-settings: URI や COM(WScript.Shell) 経由に切替
2. UI Automation (System.Windows.Automation) を使う
3. computer_use による画面操作に切替
4. AutoHotkey を winget install AutoHotkey.AutoHotkey で導入

## Related
powershell, registry, permission-policy, verification

## Prohibited
- 重要システム設定(UAC/Defender/ファイアウォール無効化)を承認なしで変更しない
- ユーザー作業中のウィンドウを閉じない
- Approval 対象（permission-policy 参照）は実行前に確認する。
