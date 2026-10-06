---
name: github-research
description: gh CLI で GitHub のリポジトリ・Issue・PR を調査する
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - research
    category: research
  kiridev:
    namespace: kiridev
    category: research
    triggers:
    - GitHub
    - issue
    - リポジトリ調査
    - gh
    required_tools:
    - terminal
    - web_extract
    optional_tools:
    - web_search
    dependencies:
    - gh
    conflicts: []
    workflow: see '## Procedure'
    verification: 回答に repo URL・最終更新日・ライセンス・最新リリースが含まれる
    fallback:
    - gh 不在は Get-Command gh -> winget install GitHub.cli
    - 未認証・レート制限時は web_extract で github.com ページを直接取得
    - git clone --depth 1 を別の空ディレクトリに行いローカル検索
    risk_level: low
    related:
    - git
    - primary-source-first
    - technical-docs-research
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# github-research

gh CLI で GitHub のリポジトリ・Issue・PR を調査する

## When to Use
Trigger: GitHub, issue, リポジトリ調査, gh

## Tools
- required: terminal, web_extract
- optional: web_search
- dependencies: gh（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. gh auth status で認証状態を確認する
2. gh search repos "<query>" --sort stars --limit 10 で候補を探す
3. gh repo view <o>/<r> と gh release list -R <o>/<r> で活動状況・最新版を確認
4. gh issue list -R <o>/<r> --search "<kw>" / gh pr view <n> で議論を読む
5. gh api repos/<o>/<r>/contents/<path> でファイルを取得する

## Verification
回答に repo URL・最終更新日・ライセンス・最新リリースが含まれる

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. gh 不在は Get-Command gh -> winget install GitHub.cli
2. 未認証・レート制限時は web_extract で github.com ページを直接取得
3. git clone --depth 1 を別の空ディレクトリに行いローカル検索

## Related
git, primary-source-first, technical-docs-research

## Prohibited
- Issue/PR へのコメント・作成・star を承認なしで行わない
- トークンを出力・送信しない
- 取得したスクリプトを未確認で実行しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
