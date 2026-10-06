---
name: competitive-research
description: 競合製品・サービスの機能と価格を比較調査する
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
    - 競合調査
    - 比較
    - 競合分析
    - alternatives
    required_tools:
    - web_search
    - web_extract
    optional_tools:
    - write_file
    - browser_navigate
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 表の全セルに出典があり、取得日が明記されている
    fallback:
    - 価格非公開は「要問い合わせ」と記載し推測しない
    - ページ取得不可は browser_navigate か web-archiving
    - OSS は gh repo view で star・更新日を補完
    risk_level: low
    related:
    - product-research
    - market-research
    - web-research
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# competitive-research

競合製品・サービスの機能と価格を比較調査する

## When to Use
Trigger: 競合調査, 比較, 競合分析, alternatives

## Tools
- required: web_search, web_extract
- optional: write_file, browser_navigate
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 対象領域の主要競合を 3〜8 件リストアップ(公式サイト・GitHub・比較記事)
2. 各社の公式 Pricing・Features・Docs ページを web_extract で取得
3. 比較軸(機能・価格・ライセンス・対応 OS・更新頻度)の表を Markdown で作成
4. 強み・弱み・差別化ポイントを根拠 URL 付きで記述する

## Verification
表の全セルに出典があり、取得日が明記されている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 価格非公開は「要問い合わせ」と記載し推測しない
2. ページ取得不可は browser_navigate か web-archiving
3. OSS は gh repo view で star・更新日を補完

## Related
product-research, market-research, web-research

## Prohibited
- 競合サービスへ問い合わせ・登録・購入をしない
- 非公開情報の入手を試みない
- Approval 対象（permission-policy 参照）は実行前に確認する。
