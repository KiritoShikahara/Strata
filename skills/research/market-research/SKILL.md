---
name: market-research
description: 市場規模・動向・統計を出典付きで調査する
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
    - 市場調査
    - 市場規模
    - 動向
    - 統計
    required_tools:
    - web_search
    - web_extract
    optional_tools:
    - execute_code
    - write_file
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 全数値に出典・年・単位があり、ソース間の差異が説明されている
    fallback:
    - 有料レポートは公開要約・プレスリリースのみ使い、全文は取得しない
    - PDF は universal-document-ingestion で抽出
    - 数値が見つからなければ推計と明記し計算根拠を示す
    risk_level: low
    related:
    - competitive-research
    - fact-checking
    - source-verification
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# market-research

市場規模・動向・統計を出典付きで調査する

## When to Use
Trigger: 市場調査, 市場規模, 動向, 統計

## Tools
- required: web_search, web_extract
- optional: execute_code, write_file
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 政府統計(e-Stat)・業界団体・上場企業 IR・調査会社の公開資料を検索する
2. 数値は定義・対象年・通貨・単位とともに web_extract で転記する
3. 複数ソースの数値差を比較し、差の理由(定義・年)を注記する
4. 必要なら execute_code(pandas)で集計・表にし結論を整理

## Verification
全数値に出典・年・単位があり、ソース間の差異が説明されている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 有料レポートは公開要約・プレスリリースのみ使い、全文は取得しない
2. PDF は universal-document-ingestion で抽出
3. 数値が見つからなければ推計と明記し計算根拠を示す

## Related
competitive-research, fact-checking, source-verification

## Prohibited
- 有料レポートの不正入手をしない
- 推計値を公表値として書かない
- 購入を承認なしで行わない
- Approval 対象（permission-policy 参照）は実行前に確認する。
