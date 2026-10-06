---
name: independent-review
description: 実装者と別視点・別コンテキストでの独立検証
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - quality
    category: quality
  kiridev:
    namespace: kiridev
    category: quality
    triggers:
    - 独立レビュー
    - セカンドオピニオン
    - 別視点
    - クロスチェック
    required_tools:
    - terminal
    - read_file
    - delegate_task
    optional_tools:
    - search_files
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 独立した判定結果と実行ログがあり、不一致が解消または明記されている
    fallback:
    - delegate_task 不可 → 時間を置き要件のみから再レビュー
    - 別モデル利用不可 → チェックリスト方式で自己検証し限界を明記
    risk_level: low
    related:
    - code-review
    - verification
    - model-router
    - spec-compliance
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# independent-review

実装者と別視点・別コンテキストでの独立検証

## When to Use
Trigger: 独立レビュー, セカンドオピニオン, 別視点, クロスチェック

## Tools
- required: terminal, read_file, delegate_task
- optional: search_files
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 実装者の説明を渡さず、要件と成果物(diff/ファイル)のみをレビュアーへ渡す
2. delegate_task または別モデル (model-router) で readonly レビューを依頼
3. レビュアーに受け入れ基準の再導出とテスト実行を求める
4. 実装者の結論と照合し、不一致点を調査して結論を出す

## Verification
独立した判定結果と実行ログがあり、不一致が解消または明記されている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. delegate_task 不可 → 時間を置き要件のみから再レビュー
2. 別モデル利用不可 → チェックリスト方式で自己検証し限界を明記

## Related
code-review, verification, model-router, spec-compliance

## Prohibited
- 同一コンテキストの結論を独立と称さない
- レビュアーに書込権限を与えない
- Approval 対象（permission-policy 参照）は実行前に確認する。
