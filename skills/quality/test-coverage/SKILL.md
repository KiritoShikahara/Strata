---
name: test-coverage
description: テストカバレッジを計測し未検証領域を特定
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
    - カバレッジ
    - coverage
    - テスト網羅
    - 未テスト
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - write_file
    dependencies:
    - coverage
    - pytest-cov
    - c8
    conflicts: []
    workflow: see '## Procedure'
    verification: カバレッジ率の前後比較とテスト追加後の再計測結果がある
    fallback:
    - pytest-cov 無し → pip install pytest-cov / python -m coverage run -m pytest
    - ツール不可 → 手動で分岐を列挙しテスト有無を表にする
    risk_level: low
    related:
    - testing
    - regression-testing
    - dead-code-removal
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# test-coverage

テストカバレッジを計測し未検証領域を特定

## When to Use
Trigger: カバレッジ, coverage, テスト網羅, 未テスト

## Tools
- required: terminal, read_file
- optional: write_file
- dependencies: coverage, pytest-cov, c8（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Python: pytest --cov=src --cov-report=term-missing --cov-branch
2. JS: npx c8 npm test もしくは jest --coverage
3. term-missing の未カバー行を読み、重要分岐（エラー/境界）を優先抽出
4. 優先度の高い未カバーに対しテスト追加を提案/実装
5. 数値だけでなくアサーションの質も確認

## Verification
カバレッジ率の前後比較とテスト追加後の再計測結果がある

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. pytest-cov 無し → pip install pytest-cov / python -m coverage run -m pytest
2. ツール不可 → 手動で分岐を列挙しテスト有無を表にする

## Related
testing, regression-testing, dead-code-removal

## Prohibited
- 数値目的の無意味なテストを書かない
- カバレッジ除外設定で数値を水増ししない
- Approval 対象（permission-policy 参照）は実行前に確認する。
