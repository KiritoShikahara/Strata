---
name: testing
description: テスト設計・実行・失敗解析（pytest/jest/dotnet test 等）
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
    - テスト
    - pytest
    - jest
    - unit test
    - カバレッジ
    - CI
    required_tools:
    - terminal
    - read_file
    - write_file
    optional_tools:
    - patch
    - search_files
    dependencies:
    - pytest
    conflicts: []
    workflow: see '## Procedure'
    verification: テストコマンドの終了コードが 0 で、追加テストが実装を壊すと失敗することを確認済み
    fallback:
    - pip install pytest / npm i -D jest で導入
    - 依存が壊れていれば venv を作り直す（python -m venv .venv）
    - ローカルで不可なら Docker/WSL 上で実行する
    risk_level: low
    related:
    - tdd
    - debugging
    - verification
    - refactoring
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# testing

テスト設計・実行・失敗解析（pytest/jest/dotnet test 等）

## When to Use
Trigger: テスト, pytest, jest, unit test, カバレッジ, CI

## Tools
- required: terminal, read_file, write_file
- optional: patch, search_files
- dependencies: pytest（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 構成から runner を特定（pyproject.toml/package.json/*.csproj）
2. 対象テストのみ先に実行: pytest -q -x tests\test_x.py / npm test -- <pattern> / dotnet test --filter
3. 新規テストは正常系・境界値・異常系を AAA 形式で書く
4. 失敗は出力全文から原因を切り分け、テスト不備か実装不備か判定する
5. 最後に全体実行し pytest --cov 等でカバレッジを確認する

## Verification
テストコマンドの終了コードが 0 で、追加テストが実装を壊すと失敗することを確認済み

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. pip install pytest / npm i -D jest で導入
2. 依存が壊れていれば venv を作り直す（python -m venv .venv）
3. ローカルで不可なら Docker/WSL 上で実行する

## Related
tdd, debugging, verification, refactoring

## Prohibited
- テストの削除・skip・期待値の改ざんで通さない
- 本番 DB・外部 API への実接続テストを承認なしで実行しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
