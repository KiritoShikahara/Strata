---
name: fact-checking
description: 主張の真偽を証拠に基づき判定する
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
    - ファクトチェック
    - 真偽
    - 本当に
    - 裏取り
    required_tools:
    - web_search
    - web_extract
    optional_tools:
    - browser_navigate
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 全主張に判定・根拠 URL・確認日が付いている
    fallback:
    - 一次情報不在は「検証不能」と判定し推測で埋めない
    - FactCheck 系サイトは補助とし元ソースへ遡る
    - 削除済み情報は web-archiving で確認
    risk_level: low
    related:
    - source-verification
    - primary-source-first
    - web-archiving
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# fact-checking

主張の真偽を証拠に基づき判定する

## When to Use
Trigger: ファクトチェック, 真偽, 本当に, 裏取り

## Tools
- required: web_search, web_extract
- optional: browser_navigate
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 検証対象の主張を 1 文ずつ分解し、数値・固有名詞・日付を抽出する
2. 一次情報・公的統計・原論文を検索し、主張と直接照合する
3. 反証になる情報も意図的に検索する(<主張> 誤り / debunk)
4. 判定(正しい/部分的/誤り/検証不能)と根拠 URL を表で示す

## Verification
全主張に判定・根拠 URL・確認日が付いている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 一次情報不在は「検証不能」と判定し推測で埋めない
2. FactCheck 系サイトは補助とし元ソースへ遡る
3. 削除済み情報は web-archiving で確認

## Related
source-verification, primary-source-first, web-archiving

## Prohibited
- 検証前に結論を決めない
- 個人・団体への断定的中傷表現を使わない
- Approval 対象（permission-policy 参照）は実行前に確認する。
