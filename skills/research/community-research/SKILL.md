---
name: community-research
description: Reddit・HN・フォーラムの評判と実体験を調べる
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
    - 評判
    - Reddit
    - Hacker News
    - フォーラム
    - 口コミ
    required_tools:
    - web_search
    - web_extract
    optional_tools:
    - browser_navigate
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 意見ごとにスレッド URL と日付があり、賛否が両方示されている
    fallback:
    - Reddit 取得不可は URL 末尾に .json を付けて Invoke-RestMethod
    - HN は https://hn.algolia.com/api/v1/search?query=<kw> を利用
    - ブラウザ操作は browser-automation に切替
    risk_level: low
    related:
    - x-search
    - fact-checking
    - product-research
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# community-research

Reddit・HN・フォーラムの評判と実体験を調べる

## When to Use
Trigger: 評判, Reddit, Hacker News, フォーラム, 口コミ

## Tools
- required: web_search, web_extract
- optional: browser_navigate
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. site:reddit.com / site:news.ycombinator.com / site:stackoverflow.com 付きで検索
2. 上位スレッドを web_extract で取得し、投稿日・票数・返信を確認する
3. 賛否・再現報告・回避策を分類して頻出意見を抽出する
4. 体験談は一次情報ではない旨を明記して要約する

## Verification
意見ごとにスレッド URL と日付があり、賛否が両方示されている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. Reddit 取得不可は URL 末尾に .json を付けて Invoke-RestMethod
2. HN は https://hn.algolia.com/api/v1/search?query=<kw> を利用
3. ブラウザ操作は browser-automation に切替

## Related
x-search, fact-checking, product-research

## Prohibited
- 投稿・返信・投票をしない
- ユーザー個人を特定する情報をまとめない
- Approval 対象（permission-policy 参照）は実行前に確認する。
