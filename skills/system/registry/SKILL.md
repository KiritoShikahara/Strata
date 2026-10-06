---
name: registry
description: レジストリの参照・バックアップ・変更
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
    - レジストリ
    - regedit
    - HKLM
    - HKCU
    - reg.exe
    required_tools:
    - terminal
    optional_tools:
    - read_file
    dependencies:
    - reg.exe
    conflicts: []
    workflow: see '## Procedure'
    verification: Get-ItemProperty で値が期待どおり、backup.reg が存在する
    fallback:
    - reg add / reg query に切替
    - reg import backup.reg で巻き戻す
    - Group Policy / 設定アプリ側の正規手段を使う
    risk_level: high
    related:
    - environment-variables
    - permissions-acl
    - checkpoint
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# registry

レジストリの参照・バックアップ・変更

## When to Use
Trigger: レジストリ, regedit, HKLM, HKCU, reg.exe

## Tools
- required: terminal
- optional: read_file
- dependencies: reg.exe（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Get-ItemProperty -Path "HKCU:\Software\<key>" で現在値を取得する
2. reg export "HKCU\Software\<key>" backup.reg でバックアップする
3. New-ItemProperty / Set-ItemProperty -Type DWord で変更する
4. HKLM は管理者権限と変更理由を明示して行う
5. 変更後に再取得し、必要ならアプリ再起動で反映を確認する

## Verification
Get-ItemProperty で値が期待どおり、backup.reg が存在する

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. reg add / reg query に切替
2. reg import backup.reg で巻き戻す
3. Group Policy / 設定アプリ側の正規手段を使う

## Related
environment-variables, permissions-acl, checkpoint

## Prohibited
- バックアップ無しで HKLM を変更しない
- HKLM\SYSTEM / SAM / SECURITY を変更しない
- キーの再帰削除を承認なしで行わない
- Approval 対象（permission-policy 参照）は実行前に確認する。
