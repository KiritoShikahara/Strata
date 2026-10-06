---
name: web-research
description: Web 検索で一次情報を集め要点を整理する
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
    - 調べて
    - 検索
    - web search
    - 最新情報
    required_tools:
    - web_search
    - web_extract
    optional_tools:
    - browser_navigate
    - terminal
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 各結論に URL と取得日が付いており、少なくとも 1 件は一次情報であること
    fallback:
    - web_search 失敗時はクエリを言い換え、別検索エンジンの URL を browser_navigate で開く
    - web_extract 失敗時は browser_navigate + browser_snapshot、または Invoke-WebRequest -Uri <url> で取得
    - curl 不在は Get-Command curl -> winget install cURL.cURL
    risk_level: low
    related:
    - deep-research
    - source-verification
    - primary-source-first
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# web-research

Web 検索で一次情報を集め要点を整理する

## When to Use
Trigger: 調べて, 検索, web search, 最新情報

## Tools
- required: web_search, web_extract
- optional: browser_navigate, terminal
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 調査課題を 1〜3 個の検索クエリに分解し web_search を実行する
2. 公式ドキュメント・仕様・リポジトリなど一次情報の URL を優先して選ぶ
3. web_extract で本文を取得し、日付・バージョン・著者を記録する
4. 結論と根拠 URL を対応づけて箇条書きにまとめる

## Verification
各結論に URL と取得日が付いており、少なくとも 1 件は一次情報であること

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. web_search 失敗時はクエリを言い換え、別検索エンジンの URL を browser_navigate で開く
2. web_extract 失敗時は browser_navigate + browser_snapshot、または Invoke-WebRequest -Uri <url> で取得
3. curl 不在は Get-Command curl -> winget install cURL.cURL

## Related
deep-research, source-verification, primary-source-first

## Prohibited
- ログイン必須ページの認証情報を入力しない
- Secret を検索クエリに含めない
- Approval 対象（permission-policy 参照）は実行前に確認する。
