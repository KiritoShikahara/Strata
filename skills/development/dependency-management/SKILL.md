---
name: dependency-management
description: 依存パッケージの追加・更新・脆弱性確認
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
    - 依存関係
    - パッケージ更新
    - npm
    - pip
    - NuGet
    - 脆弱性
    required_tools:
    - terminal
    - read_file
    - patch
    optional_tools:
    - web_search
    dependencies:
    - pip
    - npm
    conflicts: []
    workflow: see '## Procedure'
    verification: クリーンインストール後にビルドとテストが通り、audit の高重大度が 0
    fallback:
    - レジストリ到達不可ならミラー/キャッシュ（npm config get registry）を確認
    - 競合は venv/node_modules を再作成（確認の上）
    - Docker/WSL でクリーン環境を作り再現する
    risk_level: medium
    related:
    - build-systems
    - package-release
    - testing
    - git
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# dependency-management

依存パッケージの追加・更新・脆弱性確認

## When to Use
Trigger: 依存関係, パッケージ更新, npm, pip, NuGet, 脆弱性

## Tools
- required: terminal, read_file, patch
- optional: web_search
- dependencies: pip, npm（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. lockfile と manifest（requirements.txt/pyproject.toml/package-lock.json/*.csproj）を確認する
2. 現状確認: pip list --outdated / npm outdated / dotnet list package --outdated
3. 脆弱性: pip-audit / npm audit / dotnet list package --vulnerable
4. 更新は 1 パッケージずつ行い、changelog の破壊的変更を確認する
5. 更新ごとにテスト実行し lockfile も一緒にコミットする

## Verification
クリーンインストール後にビルドとテストが通り、audit の高重大度が 0

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. レジストリ到達不可ならミラー/キャッシュ（npm config get registry）を確認
2. 競合は venv/node_modules を再作成（確認の上）
3. Docker/WSL でクリーン環境を作り再現する

## Related
build-systems, package-release, testing, git

## Prohibited
- lockfile の手動編集や一括メジャーアップデートをしない
- 出所不明パッケージ導入や非公式レジストリへの認証情報送信をしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
