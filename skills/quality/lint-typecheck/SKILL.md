---
name: lint-typecheck
description: lint と型チェックを実行して指摘を解消
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
    - lint
    - 型チェック
    - ruff
    - mypy
    - eslint
    - tsc
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - patch
    dependencies:
    - ruff
    - mypy
    - eslint
    - tsc
    conflicts: []
    workflow: see '## Procedure'
    verification: ruff/mypy/eslint/tsc がすべて exit code 0
    fallback:
    - ruff 無し → pip install ruff / flake8
    - tsc 無し → npm i -D typescript / npx -p typescript tsc
    - 設定が無ければ既定設定で実行し旨を記録
    risk_level: low
    related:
    - static-analysis
    - testing
    - code-review
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# lint-typecheck

lint と型チェックを実行して指摘を解消

## When to Use
Trigger: lint, 型チェック, ruff, mypy, eslint, tsc

## Tools
- required: terminal, read_file
- optional: patch
- dependencies: ruff, mypy, eslint, tsc（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 設定確認: pyproject.toml / .eslintrc* / tsconfig.json
2. Python: ruff check . ; mypy src ； JS/TS: npx eslint . ; npx tsc --noEmit
3. 自動修正可は ruff check --fix / eslint --fix（差分を確認）
4. 残りは原因を修正（型を正しく付ける）
5. 再実行して0件を確認

## Verification
ruff/mypy/eslint/tsc がすべて exit code 0

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. ruff 無し → pip install ruff / flake8
2. tsc 無し → npm i -D typescript / npx -p typescript tsc
3. 設定が無ければ既定設定で実行し旨を記録

## Related
static-analysis, testing, code-review

## Prohibited
- # type: ignore / eslint-disable の乱用禁止
- 大規模な自動整形を無関係ファイルへ波及させない
- Approval 対象（permission-policy 参照）は実行前に確認する。
