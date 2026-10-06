---
name: overengineering-detection
description: 過剰設計・不要な複雑性の兆候を検出して指摘
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
    - 過剰設計
    - 複雑
    - オーバーエンジニアリング
    - 抽象化しすぎ
    required_tools:
    - terminal
    - read_file
    - search_files
    optional_tools: []
    dependencies:
    - radon
    - lizard
    conflicts: []
    workflow: see '## Procedure'
    verification: 指摘ごとに file:line・複雑度値・簡素化案が揃っている
    fallback:
    - radon 無し → pip install radon / 手動でネスト深さを数える
    - 主観的判断は「提案」として区別
    risk_level: low
    related:
    - simplicity-yagni
    - code-review
    - dead-code-removal
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# overengineering-detection

過剰設計・不要な複雑性の兆候を検出して指摘

## When to Use
Trigger: 過剰設計, 複雑, オーバーエンジニアリング, 抽象化しすぎ

## Tools
- required: terminal, read_file, search_files
- optional: -
- dependencies: radon, lizard（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 複雑度計測: radon cc src -s -n C / lizard -C 15 src
2. 実装が1つだけの抽象層・Factory/Manager 乱立・多段委譲を rg で列挙
3. 要件の変更頻度に比べ設定可能/拡張点が多すぎないか確認
4. 行数・ファイル数・依存数を同等機能の素朴実装と比較
5. 簡素化案と影響を提示

## Verification
指摘ごとに file:line・複雑度値・簡素化案が揃っている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. radon 無し → pip install radon / 手動でネスト深さを数える
2. 主観的判断は「提案」として区別

## Related
simplicity-yagni, code-review, dead-code-removal

## Prohibited
- 好みだけで大規模書換を強行しない
- 承認なしに設計を変更しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
