---
name: regression-testing
description: 変更で既存機能が壊れていないかを回帰テストで確認
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
    - 回帰テスト
    - リグレッション
    - 既存テスト
    - 壊れていないか
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - search_files
    dependencies:
    - pytest
    - npm
    - git
    conflicts: []
    workflow: see '## Procedure'
    verification: 変更前後で pass/fail 数が比較でき、新規失敗が0
    fallback:
    - 自動テスト無し → 手動の再現手順＋characterization test を作成
    - pytest 無し → pip install pytest / python -m unittest
    - 環境依存 → Docker/WSL で実行
    risk_level: low
    related:
    - testing
    - test-coverage
    - verification
    - debugging
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# regression-testing

変更で既存機能が壊れていないかを回帰テストで確認

## When to Use
Trigger: 回帰テスト, リグレッション, 既存テスト, 壊れていないか

## Tools
- required: terminal, read_file
- optional: search_files
- dependencies: pytest, npm, git（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 変更前の基準を取得: git stash; pytest -q または npm test を実行し結果を保存
2. 変更後に同コマンドを実行し 失敗テストを差分比較
3. 影響範囲を git diff --name-only と依存関係から特定し関連テストを優先
4. バグ修正なら再現テストを先に追加（修正前に失敗することを確認）
5. 新規失敗は原因を切り分け（変更起因 / flaky）、3回再実行で判定

## Verification
変更前後で pass/fail 数が比較でき、新規失敗が0

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 自動テスト無し → 手動の再現手順＋characterization test を作成
2. pytest 無し → pip install pytest / python -m unittest
3. 環境依存 → Docker/WSL で実行

## Related
testing, test-coverage, verification, debugging

## Prohibited
- 失敗テストを削除/skip/弱体化して通さない
- git stash で他者の変更を失わない (checkpoint 確認)
- Approval 対象（permission-policy 参照）は実行前に確認する。
