---
name: refactoring
description: 挙動を変えず構造を改善する安全なリファクタリング
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
    - リファクタ
    - refactor
    - 整理
    - 重複排除
    - 命名変更
    required_tools:
    - terminal
    - read_file
    - patch
    - search_files
    optional_tools:
    - execute_code
    dependencies:
    - git
    conflicts: []
    workflow: see '## Procedure'
    verification: リファクタ前後でテストが同一結果（全通過）で、公開 API の差分が無い
    fallback:
    - テストが書けない場合は小さな単位に分け手動で入出力を比較する
    - IDE（VS Code/Rider）のリネーム機能を使う
    - 壊れたら git restore か checkpoint の地点へ戻る
    risk_level: medium
    related:
    - testing
    - git
    - debugging
    - verification
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# refactoring

挙動を変えず構造を改善する安全なリファクタリング

## When to Use
Trigger: リファクタ, refactor, 整理, 重複排除, 命名変更

## Tools
- required: terminal, read_file, patch, search_files
- optional: execute_code
- dependencies: git（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 着手前に git status を確認し、テストを実行して緑のベースラインを取る
2. 特性化テストが無ければ現挙動を固定するテストを先に追加する
3. rg -n "<symbol>" で全参照を洗い、1 種類の変更（rename/extract）を小さく行う
4. 各ステップ後にテストを実行し、緑のまま git commit で区切る
5. git diff --stat で意図外の差分が無いか確認する

## Verification
リファクタ前後でテストが同一結果（全通過）で、公開 API の差分が無い

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. テストが書けない場合は小さな単位に分け手動で入出力を比較する
2. IDE（VS Code/Rider）のリネーム機能を使う
3. 壊れたら git restore か checkpoint の地点へ戻る

## Related
testing, git, debugging, verification

## Prohibited
- 機能追加・挙動変更を同じコミットに混ぜない
- git reset --hard / 大量ファイル削除は承認なしで行わない
- Approval 対象（permission-policy 参照）は実行前に確認する。
