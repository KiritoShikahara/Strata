---
name: source-verification
description: 情報源の信頼性と日付・一次性を検証する
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
    - 出典確認
    - 信頼性
    - ソース検証
    - 本当か
    required_tools:
    - web_search
    - web_extract
    optional_tools:
    - browser_navigate
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 各主張に 一次情報URL・日付・信頼度 が付与されている
    fallback:
    - 一次情報が見つからなければ web-archiving で過去版を確認
    - 照合先が 1 つしか無い場合は「単一ソース」と明記
    - web ツール不通は browser_navigate で直接公式サイトを開く
    risk_level: low
    related:
    - fact-checking
    - primary-source-first
    - web-archiving
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# source-verification

情報源の信頼性と日付・一次性を検証する

## When to Use
Trigger: 出典確認, 信頼性, ソース検証, 本当か

## Tools
- required: web_search, web_extract
- optional: browser_navigate
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 情報の元発信者を辿り、一次情報(公式サイト・論文・リリースノート)に到達する
2. 公開日・更新日・対象バージョンを確認し古い情報を除外する
3. 独立した 2 つ以上の情報源で主張を照合する
4. 信頼度(高/中/低)と理由を付けて報告する

## Verification
各主張に 一次情報URL・日付・信頼度 が付与されている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 一次情報が見つからなければ web-archiving で過去版を確認
2. 照合先が 1 つしか無い場合は「単一ソース」と明記
3. web ツール不通は browser_navigate で直接公式サイトを開く

## Related
fact-checking, primary-source-first, web-archiving

## Prohibited
- SNS の伝聞だけで確定扱いにしない
- 検証できない主張を補完して書かない
- Approval 対象（permission-policy 参照）は実行前に確認する。
