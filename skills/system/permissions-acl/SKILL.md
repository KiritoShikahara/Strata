---
name: permissions-acl
description: ファイル/フォルダの ACL・所有者・権限の確認と変更
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
    - 権限
    - ACL
    - icacls
    - アクセス拒否
    - 所有者
    required_tools:
    - terminal
    optional_tools: []
    dependencies:
    - icacls
    conflicts: []
    workflow: see '## Procedure'
    verification: icacls の出力が意図した ACE のみで対象操作が成功する
    fallback:
    - Set-Acl (System.Security.AccessControl) を使う
    - takeown /f <path> は所有者確認後のみ
    - 管理者昇格を依頼
    risk_level: high
    related:
    - filesystem
    - permission-audit
    - registry
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# permissions-acl

ファイル/フォルダの ACL・所有者・権限の確認と変更

## When to Use
Trigger: 権限, ACL, icacls, アクセス拒否, 所有者

## Tools
- required: terminal
- optional: -
- dependencies: icacls（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. icacls "<path>" / Get-Acl <path> | Format-List で現在の ACL を確認する
2. icacls <path> /save acl.bak /T で変更前 ACL を保存する
3. whoami /groups と whoami /priv で実行ユーザーの権限を確認する
4. 必要最小限のみ icacls <path> /grant "<user>:(R)" で付与する(継承は /inheritance:e)
5. 復元は icacls <dir> /restore acl.bak

## Verification
icacls の出力が意図した ACE のみで対象操作が成功する

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. Set-Acl (System.Security.AccessControl) を使う
2. takeown /f <path> は所有者確認後のみ
3. 管理者昇格を依頼

## Related
filesystem, permission-audit, registry

## Prohibited
- Everyone:F の付与や /T による広範囲変更を承認なしで行わない
- システムフォルダの ACL を変更しない
- takeown /R を承認なしで実行しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
