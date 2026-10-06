---
name: simplicity-yagni
description: YAGNI 観点で不要な機能・抽象を排して最小実装にする
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
    - YAGNI
    - シンプル
    - 最小実装
    - 過剰機能
    required_tools:
    - terminal
    - read_file
    - search_files
    optional_tools:
    - patch
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 簡素化後も全テスト通過し、要件に対応しない追加物が無い
    fallback:
    - 判断が割れる → 削除せず指摘として提示
    - テスト不足 → テスト追加後に簡素化
    risk_level: low
    related:
    - overengineering-detection
    - dead-code-removal
    - code-review
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# simplicity-yagni

YAGNI 観点で不要な機能・抽象を排して最小実装にする

## When to Use
Trigger: YAGNI, シンプル, 最小実装, 過剰機能

## Tools
- required: terminal, read_file, search_files
- optional: patch
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 要件に対する変更を列挙し、要件に無い機能/設定/フックを抽出
2. 1実装しか無いインターフェース・未使用パラメータ・早すぎる汎用化を rg で探す
3. 標準ライブラリ/既存関数で置換できるものを確認
4. 削除・簡素化案を提示し、テスト通過を確認して適用

## Verification
簡素化後も全テスト通過し、要件に対応しない追加物が無い

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 判断が割れる → 削除せず指摘として提示
2. テスト不足 → テスト追加後に簡素化

## Related
overengineering-detection, dead-code-removal, code-review

## Prohibited
- 要件を満たす機能まで削らない
- 依頼範囲外のリファクタを行わない
- Approval 対象（permission-policy 参照）は実行前に確認する。
