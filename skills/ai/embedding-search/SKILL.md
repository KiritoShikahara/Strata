---
name: embedding-search
description: 埋め込みモデルによる意味検索を実装する
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
    - 埋め込み
    - embedding
    - 類似検索
    - ベクトル
    required_tools:
    - terminal
    - execute_code
    optional_tools:
    - write_file
    dependencies:
    - python
    - numpy
    conflicts: []
    workflow: see '## Procedure'
    verification: 類似ペアのスコアが非類似ペアより有意に高い
    fallback:
    - ローカル埋め込み不可は pip install sentence-transformers(multilingual-e5 等)
    - 日本語精度不足は多言語対応モデルへ変更
    - GPU 不足は CPU 実行・バッチ縮小
    risk_level: low
    related:
    - rag
    - model-selection
    - llama-cpp
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# embedding-search

埋め込みモデルによる意味検索を実装する

## When to Use
Trigger: 埋め込み, embedding, 類似検索, ベクトル

## Tools
- required: terminal, execute_code
- optional: write_file
- dependencies: python, numpy（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 埋め込み源を決定: llama-server --embeddings -m <embed.gguf> --port 8081 または sentence-transformers
2. POST /v1/embeddings で入力を埋め込み、ベクトル次元を確認
3. コサイン類似度で上位 k 件を取得するスクリプトを作る
4. 既知の類似/非類似ペアで順位が妥当か確認

## Verification
類似ペアのスコアが非類似ペアより有意に高い

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. ローカル埋め込み不可は pip install sentence-transformers(multilingual-e5 等)
2. 日本語精度不足は多言語対応モデルへ変更
3. GPU 不足は CPU 実行・バッチ縮小

## Related
rag, model-selection, llama-cpp

## Prohibited
- 機密データを外部 API に承認なしで送らない
- Approval 対象（permission-policy 参照）は実行前に確認する。
