---
name: context-compression
description: 長い会話・資料を情報を保って圧縮する
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
    - 要約
    - 圧縮
    - compact
    - コンテキスト圧縮
    required_tools:
    - read_file
    - write_file
    optional_tools:
    - delegate_task
    - memory
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 要約のみで次の作業を再開でき、重要な数値・パスが欠落していない
    fallback:
    - 要約でも長い場合は階層要約(章→全体)
    - 精度が重要な箇所は要約せず該当範囲のみ再読込
    - ローカルモデル不調時は抽出的要約(見出し+先頭文)
    risk_level: low
    related:
    - context-engineering
    - memory-design
    - checkpoint
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# context-compression

長い会話・資料を情報を保って圧縮する

## When to Use
Trigger: 要約, 圧縮, compact, コンテキスト圧縮

## Tools
- required: read_file, write_file
- optional: delegate_task, memory
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 圧縮対象を「決定事項/未解決/重要ファイルパス/制約/次の作業」に分類
2. 決定事項・パス・コマンド・数値は原文のまま残し、経緯のみ要約
3. 要約を notes\summary.md に保存し元ログへのポインタを付ける
4. 長大資料は delegate_task で章ごとに要約後、統合する

## Verification
要約のみで次の作業を再開でき、重要な数値・パスが欠落していない

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 要約でも長い場合は階層要約(章→全体)
2. 精度が重要な箇所は要約せず該当範囲のみ再読込
3. ローカルモデル不調時は抽出的要約(見出し+先頭文)

## Related
context-engineering, memory-design, checkpoint

## Prohibited
- 原本を要約で上書きしない
- Secret を要約に含めない
- Approval 対象（permission-policy 参照）は実行前に確認する。
