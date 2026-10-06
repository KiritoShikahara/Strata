---
name: remote-execution
description: リモートホストでのコマンド実行(WinRM/SSH)
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
    - リモート実行
    - Invoke-Command
    - WinRM
    - PSSession
    required_tools:
    - terminal
    optional_tools: []
    dependencies:
    - ssh
    - winrm
    conflicts: []
    workflow: see '## Procedure'
    verification: 読取系コマンドの出力が期待どおりで PSSession が残っていない
    fallback:
    - 'WinRM 不可: ssh <host> "<cmd>"'
    - PsExec (Sysinternals) は承認後のみ
    - スクリプトを scp で転送し実行を依頼
    risk_level: high
    related:
    - ssh
    - powershell
    - permission-policy
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# remote-execution

リモートホストでのコマンド実行(WinRM/SSH)

## When to Use
Trigger: リモート実行, Invoke-Command, WinRM, PSSession

## Tools
- required: terminal
- optional: -
- dependencies: ssh, winrm（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 対象・目的・実行コマンドを事前に列挙し承認を得る
2. Test-WSMan <host> または ssh <host> で到達性を確認する
3. Invoke-Command -ComputerName <h> -ScriptBlock { ... } -Credential $cred(読取系から開始)
4. PowerShell 7 は -HostName <h> -UserName <u> で SSH トランスポートを使う
5. 結果と終了コードを回収し Remove-PSSession で接続を閉じる

## Verification
読取系コマンドの出力が期待どおりで PSSession が残っていない

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. WinRM 不可: ssh <host> "<cmd>"
2. PsExec (Sysinternals) は承認後のみ
3. スクリプトを scp で転送し実行を依頼

## Related
ssh, powershell, permission-policy

## Prohibited
- 承認なしで本番/他者ホストにコマンドを実行しない
- 資格情報を平文でスクリプトに埋め込まない
- TrustedHosts を * にしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
