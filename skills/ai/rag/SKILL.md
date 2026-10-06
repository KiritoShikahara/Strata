---
name: rag
description: ドキュメント検索拡張生成(RAG)を構築・運用する
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
    - RAG
    - 検索拡張
    - ベクトルDB
    - ナレッジ検索
    required_tools:
    - terminal
    - write_file
    - read_file
    optional_tools:
    - execute_code
    dependencies:
    - python
    - chromadb
    conflicts: []
    workflow: see '## Procedure'
    verification: 評価質問で回答が取得チャンクに基づき、出典が提示される
    fallback:
    - chromadb 不可は pip install faiss-cpu か SQLite+numpy の総当たり
    - pip 不可は Get-Command python -> winget install Python.Python.3.12
    - 検索精度不足は BM25(rank-bm25)との併用
    risk_level: low
    related:
    - embedding-search
    - context-engineering
    - universal-document-ingestion
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# rag

ドキュメント検索拡張生成(RAG)を構築・運用する

## When to Use
Trigger: RAG, 検索拡張, ベクトルDB, ナレッジ検索

## Tools
- required: terminal, write_file, read_file
- optional: execute_code
- dependencies: python, chromadb（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 対象文書を収集しチャンク化(500〜1000 文字、重なり 10〜20%)する
2. embedding-search skill で埋め込みを作成し ChromaDB/FAISS(rag\index)に保存
3. 質問を埋め込み、上位 k=3〜5 件を取得してプロンプトに出典付きで投入
4. 代表質問で回答の根拠一致を確認し、チャンクサイズ・k を調整

## Verification
評価質問で回答が取得チャンクに基づき、出典が提示される

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. chromadb 不可は pip install faiss-cpu か SQLite+numpy の総当たり
2. pip 不可は Get-Command python -> winget install Python.Python.3.12
3. 検索精度不足は BM25(rank-bm25)との併用

## Related
embedding-search, context-engineering, universal-document-ingestion

## Prohibited
- 機密文書を外部 Embedding API へ承認なしで送らない
- Approval 対象（permission-policy 参照）は実行前に確認する。
