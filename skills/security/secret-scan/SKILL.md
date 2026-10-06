---
name: secret-scan
description: リポジトリ内の API キー・認証情報の検出
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
    - シークレット
    - APIキー
    - 漏洩
    - gitleaks
    - トークン
    required_tools:
    - terminal
    - search_files
    optional_tools:
    - read_file
    dependencies:
    - gitleaks
    - git
    conflicts: []
    workflow: see '## Procedure'
    verification: gitleaks 終了コード 0、または全検出に対処方針がある
    fallback:
    - '不在: winget install Gitleaks.Gitleaks'
    - trufflehog / detect-secrets (pip install detect-secrets)
    - git log -p -S<pattern> で履歴検索
    - Docker の zricethezav/gitleaks
    risk_level: medium
    related:
    - security-review
    - git
    - permission-audit
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# secret-scan

リポジトリ内の API キー・認証情報の検出

## When to Use
Trigger: シークレット, APIキー, 漏洩, gitleaks, トークン

## Tools
- required: terminal, search_files
- optional: read_file
- dependencies: gitleaks, git（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. gitleaks detect --source . --redact -v で作業ツリーと履歴を検査する
2. gitleaks 不在時は Select-String で AKIA|ghp_|sk-|BEGIN (RSA|OPENSSH) PRIVATE KEY を検索する
3. .env・*.pem・*.pfx・appsettings*.json・.git 管理対象を git ls-files で確認する
4. 検出値は必ずマスクして報告(先頭 4 文字まで)し、場所のみ示す
5. 漏洩時は失効→再発行→履歴除去→.gitignore の順を提案する

## Verification
gitleaks 終了コード 0、または全検出に対処方針がある

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 不在: winget install Gitleaks.Gitleaks
2. trufflehog / detect-secrets (pip install detect-secrets)
3. git log -p -S<pattern> で履歴検索
4. Docker の zricethezav/gitleaks

## Related
security-review, git, permission-audit

## Prohibited
- Secret の実値を出力・ログ・外部へ送らない
- 失効/ローテーションを承認なしで実行しない
- git filter-repo / force push を承認なしで行わない
- Approval 対象（permission-policy 参照）は実行前に確認する。
