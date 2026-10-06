---
name: product-research
description: 製品・ツールの仕様・評価・導入可否を調べる
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
    - 製品調査
    - ツール選定
    - おすすめ
    - 導入検討
    required_tools:
    - web_search
    - web_extract
    optional_tools:
    - terminal
    - browser_navigate
    dependencies:
    - winget
    conflicts: []
    workflow: see '## Procedure'
    verification: 要件ごとに適合/不適合と根拠 URL が記載されている
    fallback:
    - winget 不在は Get-Command winget -> Microsoft Store の App Installer
    - winget 未掲載は choco search / scoop search を試す
    - 公式不明の場合は GitHub Releases を一次情報とする
    risk_level: low
    related:
    - competitive-research
    - community-research
    - github-research
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# product-research

製品・ツールの仕様・評価・導入可否を調べる

## When to Use
Trigger: 製品調査, ツール選定, おすすめ, 導入検討

## Tools
- required: web_search, web_extract
- optional: terminal, browser_navigate
- dependencies: winget（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 公式サイトで機能・対応 OS・ライセンス・価格を確認する
2. winget search <name> / winget show <id> で Windows 提供状況を確認
3. GitHub の Issues・更新日とコミュニティ評判を調べる
4. 要件との適合表と推奨・非推奨理由をまとめる

## Verification
要件ごとに適合/不適合と根拠 URL が記載されている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. winget 不在は Get-Command winget -> Microsoft Store の App Installer
2. winget 未掲載は choco search / scoop search を試す
3. 公式不明の場合は GitHub Releases を一次情報とする

## Related
competitive-research, community-research, github-research

## Prohibited
- 調査目的でインストール・購入・サインアップをしない
- 広告記事を一次情報扱いしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
