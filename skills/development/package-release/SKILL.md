---
name: package-release
description: バージョニング・成果物作成・リリース準備
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
    - リリース
    - release
    - バージョン
    - タグ
    - パッケージ化
    - publish
    required_tools:
    - terminal
    - read_file
    - patch
    optional_tools:
    - write_file
    dependencies:
    - git
    conflicts: []
    workflow: see '## Procedure'
    verification: 成果物をクリーン環境へ導入して起動/import でき、ハッシュと CHANGELOG が揃っている
    fallback:
    - build ツール不足は pip install build / winget で導入
    - 署名や公開が不可なら成果物とタグまでローカルで用意し手順を提示する
    - Docker でクリーンビルドして再現性を確認
    risk_level: high
    related:
    - build-systems
    - dependency-management
    - git
    - testing
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# package-release

バージョニング・成果物作成・リリース準備

## When to Use
Trigger: リリース, release, バージョン, タグ, パッケージ化, publish

## Tools
- required: terminal, read_file, patch
- optional: write_file
- dependencies: git（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. git status がクリーンで CI/テストが緑であることを確認する
2. SemVer に従いバージョンを更新し CHANGELOG.md を git log から整理する
3. 成果物を作成: python -m build / npm pack / dotnet publish -c Release
4. Get-FileHash -Algorithm SHA256 でハッシュを記録し、別ディレクトリで導入テストする
5. git tag -a vX.Y.Z -m "..." を作成する（push・公開は承認後）

## Verification
成果物をクリーン環境へ導入して起動/import でき、ハッシュと CHANGELOG が揃っている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. build ツール不足は pip install build / winget で導入
2. 署名や公開が不可なら成果物とタグまでローカルで用意し手順を提示する
3. Docker でクリーンビルドして再現性を確認

## Related
build-systems, dependency-management, git, testing

## Prohibited
- PyPI/npm/GitHub Releases/ストアへの公開・タグ push は承認なしで行わない
- トークン・署名鍵を出力・コミットしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
