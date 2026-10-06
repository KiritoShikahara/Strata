---
name: site-navigation
description: サイト構造を辿り目的のページ・情報へ到達する
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
    - サイト内検索
    - 目的のページ
    - ナビゲーション
    - sitemap
    required_tools:
    - browser_navigate
    - browser_snapshot
    optional_tools:
    - browser_click
    - web_extract
    - terminal
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 目的ページの URL を示し、snapshot に該当記述が存在する
    fallback:
    - JS 描画で空なら browser_snapshot を待機後に取り直す
    - sitemap 無しは検索ボックスを browser_type で利用
    - アクセス拒否は web-archiving のキャッシュで代替
    risk_level: low
    related:
    - browser-automation
    - form-interaction
    - web-research
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# site-navigation

サイト構造を辿り目的のページ・情報へ到達する

## When to Use
Trigger: サイト内検索, 目的のページ, ナビゲーション, sitemap

## Tools
- required: browser_navigate, browser_snapshot
- optional: browser_click, web_extract, terminal
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. https://<host>/sitemap.xml と robots.txt を web_extract で確認する
2. 検索クエリ site:<host> <kw> で候補 URL を絞る
3. browser_navigate -> browser_snapshot でメニュー・リンク ref を確認し browser_click で遷移
4. 到達 URL と経路をメモし、目的情報を抽出する

## Verification
目的ページの URL を示し、snapshot に該当記述が存在する

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. JS 描画で空なら browser_snapshot を待機後に取り直す
2. sitemap 無しは検索ボックスを browser_type で利用
3. アクセス拒否は web-archiving のキャッシュで代替

## Related
browser-automation, form-interaction, web-research

## Prohibited
- robots.txt/利用規約に反する大量クロールをしない
- 認証回避をしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
