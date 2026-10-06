---
name: permission-audit
description: ファイル・サービス・ユーザー権限の過剰付与の監査
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - security
    category: security
  kiridev:
    namespace: kiridev
    category: security
    triggers:
    - 権限監査
    - 過剰権限
    - ACL 監査
    - 管理者
    - 最小権限
    required_tools:
    - terminal
    optional_tools:
    - read_file
    dependencies:
    - icacls
    - powershell
    conflicts: []
    workflow: see '## Procedure'
    verification: 過剰権限の一覧(対象・主体・権限)と是正案を提示
    fallback:
    - 'Get-Acl 不可: icacls <path>'
    - accesschk (Sysinternals) を導入
    - net localgroup administrators
    - Docker/WSL の getfacl/find -perm
    risk_level: low
    related:
    - permissions-acl
    - security-review
    - service-management
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# permission-audit

ファイル・サービス・ユーザー権限の過剰付与の監査

## When to Use
Trigger: 権限監査, 過剰権限, ACL 監査, 管理者, 最小権限

## Tools
- required: terminal
- optional: read_file
- dependencies: icacls, powershell（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. whoami /all で現在のトークン・グループ・特権を確認する
2. Get-LocalGroupMember Administrators で管理者メンバーを列挙する
3. (Get-Acl <path>).Access | Where IdentityReference -match "Everyone|Users" で広い許可を探す
4. Get-CimInstance Win32_Service | Where StartName -match "LocalSystem" で高権限サービスを確認する
5. 結果を読取専用で報告し、是正は permissions-acl の手順で承認後に行う

## Verification
過剰権限の一覧(対象・主体・権限)と是正案を提示

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. Get-Acl 不可: icacls <path>
2. accesschk (Sysinternals) を導入
3. net localgroup administrators
4. Docker/WSL の getfacl/find -perm

## Related
permissions-acl, security-review, service-management

## Prohibited
- 監査中に権限・ACL を変更しない
- 資格情報ダンプ(mimikatz 等)を行わない
- 他ユーザーのデータを閲覧/送信しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
