---
name: environment-bootstrap
description: 新規 Windows 環境の開発ツールと依存を整備
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - automation
    category: automation
  kiridev:
    namespace: kiridev
    category: automation
    triggers:
    - 環境構築
    - セットアップ
    - bootstrap
    - 初期設定
    - 開発環境
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - write_file
    dependencies:
    - winget
    - python
    - node
    - git
    conflicts: []
    workflow: see '## Procedure'
    verification: 各ツール --version が成功し、プロジェクトのテストが実行できる
    fallback:
    - winget 不可 → choco / scoop / 公式 installer / portable zip
    - ネイティブ不可 → WSL / Docker
    - 管理者権限が要る場合はユーザーへ確認
    risk_level: medium
    related:
    - doctor
    - powershell
    - filesystem
    - fallback
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# environment-bootstrap

新規 Windows 環境の開発ツールと依存を整備

## When to Use
Trigger: 環境構築, セットアップ, bootstrap, 初期設定, 開発環境

## Tools
- required: terminal, read_file
- optional: write_file
- dependencies: winget, python, node, git（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 現状診断: Get-Command git,python,node,pwsh,rg -ErrorAction SilentlyContinue; winget --version
2. 不足分を winget install Git.Git / Python.Python.3.12 / OpenJS.NodeJS.LTS / Microsoft.PowerShell
3. プロジェクト依存: python -m venv .venv; .\.venv\Scripts\Activate.ps1; pip install -r requirements.txt / npm ci
4. PATH 反映（新しいシェル）と実行ポリシー確認 Get-ExecutionPolicy -List
5. smoke test（--version とテスト1本）を実行し doctor で最終診断

## Verification
各ツール --version が成功し、プロジェクトのテストが実行できる

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. winget 不可 → choco / scoop / 公式 installer / portable zip
2. ネイティブ不可 → WSL / Docker
3. 管理者権限が要る場合はユーザーへ確認

## Related
doctor, powershell, filesystem, fallback

## Prohibited
- システム全体設定(PATH/ポリシー/レジストリ)の変更は承認なしにしない
- 出所不明のインストーラを実行しない
- Secret を設定ファイルへ平文で書かない
- Approval 対象（permission-policy 参照）は実行前に確認する。
