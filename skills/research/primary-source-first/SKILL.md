---
name: primary-source-first
description: 一次情報(公式・原典)を最優先で参照する
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
    - 公式
    - 一次情報
    - 原典
    - official docs
    required_tools:
    - web_search
    - web_extract
    optional_tools:
    - terminal
    dependencies:
    - gh
    conflicts: []
    workflow: see '## Procedure'
    verification: 回答の根拠の過半が公式ドメインまたは公式リポジトリの URL である
    fallback:
    - gh 不在は Get-Command gh -> winget install GitHub.cli
    - 公式が無い場合は著者本人の発表・論文・ソースコードを一次とみなす
    - 公式ページ取得不可は web-archiving の Wayback で代替
    risk_level: low
    related:
    - source-verification
    - technical-docs-research
    - github-research
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# primary-source-first

一次情報(公式・原典)を最優先で参照する

## When to Use
Trigger: 公式, 一次情報, 原典, official docs

## Tools
- required: web_search, web_extract
- optional: terminal
- dependencies: gh（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 対象の公式ドメイン・公式リポジトリ・仕様書(RFC/標準)を特定する
2. 検索クエリに site:<公式ドメイン> を付けて web_search する
3. OSS は gh repo view <owner>/<repo> や CHANGELOG・Releases を直接読む
4. 二次情報(ブログ・まとめ)は一次情報で裏取りできたものだけ採用する

## Verification
回答の根拠の過半が公式ドメインまたは公式リポジトリの URL である

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. gh 不在は Get-Command gh -> winget install GitHub.cli
2. 公式が無い場合は著者本人の発表・論文・ソースコードを一次とみなす
3. 公式ページ取得不可は web-archiving の Wayback で代替

## Related
source-verification, technical-docs-research, github-research

## Prohibited
- 非公式ミラーのバイナリ/スクリプトを実行しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
