---
name: build-systems
description: ビルド構成の作成・修復（CMake/MSBuild/npm scripts 等）
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
    - ビルド
    - build
    - CMake
    - MSBuild
    - webpack
    - vite
    - コンパイルエラー
    required_tools:
    - terminal
    - read_file
    - patch
    optional_tools:
    - search_files
    dependencies:
    - cmake
    - msbuild
    conflicts: []
    workflow: see '## Procedure'
    verification: クリーンな状態からビルドが終了コード 0 で成功し成果物が生成される
    fallback:
    - winget install Kitware.CMake / Microsoft.VisualStudio.2022.BuildTools
    - ツールチェーン差異は Docker/WSL のビルド環境で再現する
    - 別ジェネレータ（Ninja）やキャッシュ削除で再試行する
    risk_level: low
    related:
    - dependency-management
    - package-release
    - debugging
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# build-systems

ビルド構成の作成・修復（CMake/MSBuild/npm scripts 等）

## When to Use
Trigger: ビルド, build, CMake, MSBuild, webpack, vite, コンパイルエラー

## Tools
- required: terminal, read_file, patch
- optional: search_files
- dependencies: cmake, msbuild（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. ビルド定義（CMakeLists.txt/*.sln/package.json/Makefile）と必要ツールチェーンを特定する
2. クリーン環境で実行: cmake -S . -B build ; cmake --build build --config Release / dotnet build -c Release / npm run build
3. 最初のエラーから順に読み、リンク/パス/バージョン不一致を切り分ける
4. VS Build Tools 要件は vswhere.exe -latest や Developer PowerShell で確認する
5. 修正後クリーンビルドで再確認し、手順を README に反映する

## Verification
クリーンな状態からビルドが終了コード 0 で成功し成果物が生成される

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. winget install Kitware.CMake / Microsoft.VisualStudio.2022.BuildTools
2. ツールチェーン差異は Docker/WSL のビルド環境で再現する
3. 別ジェネレータ（Ninja）やキャッシュ削除で再試行する

## Related
dependency-management, package-release, debugging

## Prohibited
- エラー抑制フラグ（警告無視・テスト除外）で通さない
- システム全体の環境変数・PATH を承認なしで書き換えない
- Approval 対象（permission-policy 参照）は実行前に確認する。
