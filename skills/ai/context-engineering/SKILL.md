---
name: context-engineering
description: コンテキスト構成・長さ・配置を設計し精度を保つ
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
    - コンテキスト設計
    - 長文
    - context window
    - 文脈
    required_tools:
    - read_file
    - write_file
    optional_tools:
    - terminal
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 入力トークン + 出力予約が ctx 以内で、期待どおり回答する
    fallback:
    - ctx 超過は分割処理か RAG(rag skill)へ
    - ローカルの ctx 不足は -c 拡張(VRAM 要確認)かクラウド長文モデルへ
    - 精度低下時は few-shot を減らし指示を簡潔化
    risk_level: low
    related:
    - context-compression
    - prompt-engineering
    - context-builder
    - rag
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# context-engineering

コンテキスト構成・長さ・配置を設計し精度を保つ

## When to Use
Trigger: コンテキスト設計, 長文, context window, 文脈

## Tools
- required: read_file, write_file
- optional: terminal
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. モデルの実 ctx(-c)と出力予約分を確認し、入力の予算(トークン)を決める
2. 指示→必須情報→参考資料→質問の順に配置し、重要事項は先頭と末尾に置く
3. 不要なログ・重複を除き、必要箇所のみ行範囲指定で投入する
4. 長大化したら context-compression で要約して差し替える

## Verification
入力トークン + 出力予約が ctx 以内で、期待どおり回答する

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. ctx 超過は分割処理か RAG(rag skill)へ
2. ローカルの ctx 不足は -c 拡張(VRAM 要確認)かクラウド長文モデルへ
3. 精度低下時は few-shot を減らし指示を簡潔化

## Related
context-compression, prompt-engineering, context-builder, rag

## Prohibited
- Secret・個人情報をコンテキストに混入しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
