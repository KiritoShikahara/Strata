---
name: system-design
description: スケール・可用性・データフローを含むシステム設計
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - development
    category: development
  kiridev:
    namespace: kiridev
    category: development
    triggers:
    - システム設計
    - スケーラビリティ
    - 可用性
    - 構成図
    - キャパシティ
    required_tools:
    - read_file
    - write_file
    - web_search
    optional_tools:
    - terminal
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 設計書に数値付き要件・構成図・障害時の挙動が揃い、各要件に対応する構成要素がある
    fallback:
    - 数値不明なら仮置きし前提として明記する
    - Mermaid が描画できなければ ASCII 図で代用
    - 類似事例を web_search で調査する
    risk_level: low
    related:
    - software-architecture
    - database-design
    - requirements-analysis
    - research
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# system-design

スケール・可用性・データフローを含むシステム設計

## When to Use
Trigger: システム設計, スケーラビリティ, 可用性, 構成図, キャパシティ

## Tools
- required: read_file, write_file, web_search
- optional: terminal
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 機能/非機能要件（RPS・データ量・SLO・遅延目標）を数値で列挙する
2. 概算でストレージ・帯域・QPS を見積もる
3. コンポーネント（API/DB/キャッシュ/キュー）とデータフローを Mermaid で描く
4. 単一障害点・ボトルネック・整合性方針（強/結果整合）を洗い出す
5. 段階的移行・ロールバック手順と監視項目を設計書にまとめる

## Verification
設計書に数値付き要件・構成図・障害時の挙動が揃い、各要件に対応する構成要素がある

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 数値不明なら仮置きし前提として明記する
2. Mermaid が描画できなければ ASCII 図で代用
3. 類似事例を web_search で調査する

## Related
software-architecture, database-design, requirements-analysis, research

## Prohibited
- 本番インフラの変更・クラウド課金リソースの作成を承認なしで行わない
- 機密情報を外部サービスへ貼り付けない
- Approval 対象（permission-policy 参照）は実行前に確認する。
