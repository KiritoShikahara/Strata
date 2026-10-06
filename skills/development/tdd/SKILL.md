---
name: tdd
description: Red→Green→Refactor によるテスト駆動開発
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
    - TDD
    - テスト駆動
    - red green
    - 先にテスト
    required_tools:
    - terminal
    - write_file
    - patch
    optional_tools:
    - read_file
    dependencies:
    - pytest
    conflicts: []
    workflow: see '## Procedure'
    verification: 各サイクルで Red→Green を実行ログで確認でき、最終的に全テストが通る
    fallback:
    - テスト基盤が無ければ pytest/jest を導入
    - 外部依存が重ければ fake/stub で分離する
    - UI 等でテスト困難なら testing の統合テスト方針へ切替
    risk_level: low
    related:
    - testing
    - refactoring
    - debugging
    - git
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# tdd

Red→Green→Refactor によるテスト駆動開発

## When to Use
Trigger: TDD, テスト駆動, red green, 先にテスト

## Tools
- required: terminal, write_file, patch
- optional: read_file
- dependencies: pytest（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 振る舞いを 1 つ選び、まず失敗するテストを書く
2. テストを実行し Red（期待した理由で失敗）を確認する
3. 通すための最小実装のみ書き Green にする
4. テスト緑のまま重複排除・命名改善を行う
5. 次の振る舞いへ進み、区切りごとに git commit する

## Verification
各サイクルで Red→Green を実行ログで確認でき、最終的に全テストが通る

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. テスト基盤が無ければ pytest/jest を導入
2. 外部依存が重ければ fake/stub で分離する
3. UI 等でテスト困難なら testing の統合テスト方針へ切替

## Related
testing, refactoring, debugging, git

## Prohibited
- Red を確認せず実装を先に書かない
- テストを通すためだけの値ハードコードをしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
