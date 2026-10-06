---
name: model-evaluation
description: モデルの品質・速度を再現可能な手順で評価する
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - ai
    category: ai
  kiridev:
    namespace: kiridev
    category: ai
    triggers:
    - モデル評価
    - 比較
    - ベンチ
    - 精度確認
    required_tools:
    - terminal
    - write_file
    optional_tools:
    - execute_code
    dependencies:
    - python
    conflicts: []
    workflow: see '## Procedure'
    verification: 同条件で再実行して結果が再現する
    fallback:
    - サーバー切替は config.yaml の base_url(:8080/:1234)を変更
    - 採点困難なら上位モデルを judge として使う(明記)
    - lm-evaluation-harness(pip install lm-eval)で標準ベンチを使用
    risk_level: low
    related:
    - benchmark-suite
    - agent-evaluation
    - model-selection
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# model-evaluation

モデルの品質・速度を再現可能な手順で評価する

## When to Use
Trigger: モデル評価, 比較, ベンチ, 精度確認

## Tools
- required: terminal, write_file
- optional: execute_code
- dependencies: python（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 評価セット(10〜50 問、期待出力付き)を evals\<name>.jsonl に作成
2. 全モデルで temperature=0・同一プロンプトで /v1/chat/completions を実行
3. 正答率・形式遵守率・レイテンシ・t/s を表に集計する
4. 失敗例を分類し、結果を evals\results.md に保存

## Verification
同条件で再実行して結果が再現する

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. サーバー切替は config.yaml の base_url(:8080/:1234)を変更
2. 採点困難なら上位モデルを judge として使う(明記)
3. lm-evaluation-harness(pip install lm-eval)で標準ベンチを使用

## Related
benchmark-suite, agent-evaluation, model-selection

## Prohibited
- 評価データに本番 Secret を含めない
- Approval 対象（permission-policy 参照）は実行前に確認する。
