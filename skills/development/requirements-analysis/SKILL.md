---
name: requirements-analysis
description: 要件の抽出・曖昧さ解消・受け入れ基準の定義
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
    - 要件
    - 仕様
    - 受け入れ基準
    - ユーザーストーリー
    - 要件定義
    required_tools:
    - read_file
    - write_file
    - clarify
    optional_tools:
    - search_files
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 各要件に検証可能な受け入れ基準があり、未解決の質問が 0 か明記されている
    fallback:
    - 質問できない場合は仮定リストを作り最小実装で確認する
    - 既存実装から逆算して仕様を復元する
    - research で類似プロダクトを調べる
    risk_level: low
    related:
    - software-architecture
    - testing
    - tdd
    - strata
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# requirements-analysis

要件の抽出・曖昧さ解消・受け入れ基準の定義

## When to Use
Trigger: 要件, 仕様, 受け入れ基準, ユーザーストーリー, 要件定義

## Tools
- required: read_file, write_file, clarify
- optional: search_files
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 依頼文と既存 docs/README/issue を読み、目的・利用者・制約を抜き出す
2. 曖昧点は推測せず clarify で質問、または前提として明記する
3. ユーザーストーリーと Given/When/Then 形式の受け入れ基準を書く
4. スコープ内/外と優先度（MoSCoW）を分ける
5. 要件と受け入れ基準を docs/requirements.md に保存する

## Verification
各要件に検証可能な受け入れ基準があり、未解決の質問が 0 か明記されている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 質問できない場合は仮定リストを作り最小実装で確認する
2. 既存実装から逆算して仕様を復元する
3. research で類似プロダクトを調べる

## Related
software-architecture, testing, tdd, strata

## Prohibited
- 未確認の要件を事実として扱わない
- 利用者への外部連絡・メール送信は承認なしで行わない
- Approval 対象（permission-policy 参照）は実行前に確認する。
