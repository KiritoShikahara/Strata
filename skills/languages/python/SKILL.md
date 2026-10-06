---
name: python
description: Python スクリプト作成・venv・pytest 実行
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - languages
    category: languages
  kiridev:
    namespace: kiridev
    category: languages
    triggers:
    - Python
    - py
    - pip
    - venv
    - pytest
    required_tools:
    - terminal
    - read_file
    - patch
    optional_tools:
    - execute_code
    dependencies:
    - python
    - pip
    conflicts: []
    workflow: see '## Procedure'
    verification: python -m pytest -q が成功し ruff check が 0 件
    fallback:
    - 'python 不在: winget install Python.Python.3.12'
    - 'Microsoft Store スタブ回避: py ランチャーを使う'
    - uv (pip install uv) で環境構築
    - WSL / Docker の python イメージ
    risk_level: low
    related:
    - testing
    - debugging
    - package-management
    - powershell
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# python

Python スクリプト作成・venv・pytest 実行

## When to Use
Trigger: Python, py, pip, venv, pytest

## Tools
- required: terminal, read_file, patch
- optional: execute_code
- dependencies: python, pip（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. py -0p / python --version でインタプリタを確認する
2. python -m venv .venv; .\.venv\Scripts\Activate.ps1 で仮想環境を作る
3. python -m pip install -r requirements.txt で依存を導入する
4. 型ヒントと pathlib を使い、ruff check / ruff format で整形する
5. python -m pytest -q で検証する

## Verification
python -m pytest -q が成功し ruff check が 0 件

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. python 不在: winget install Python.Python.3.12
2. Microsoft Store スタブ回避: py ランチャーを使う
3. uv (pip install uv) で環境構築
4. WSL / Docker の python イメージ

## Related
testing, debugging, package-management, powershell

## Prohibited
- グローバル環境に承認なく pip install しない
- PyPI への publish を承認なしで行わない
- eval/exec で外部入力を実行しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
