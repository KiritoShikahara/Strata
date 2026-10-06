---
name: cmake
description: CMake による C++ プロジェクトの構成・ビルド
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - cpp-windows
    category: cpp-windows
  kiridev:
    namespace: kiridev
    category: cpp-windows
    triggers:
    - CMake
    - CMakeLists.txt
    - CMakePresets
    - ビルド構成
    required_tools:
    - terminal
    - read_file
    - patch
    optional_tools:
    - search_files
    dependencies:
    - cmake
    - ninja
    conflicts: []
    workflow: see '## Procedure'
    verification: cmake --build が成功し ctest が全件 pass
    fallback:
    - 'cmake 不在: winget install Kitware.CMake'
    - 'Ninja 不在: winget install Ninja-build.Ninja か -G "Visual Studio 17 2022"'
    - '構成キャッシュ破損: build ディレクトリを別名で新規作成して再構成'
    - msbuild で .sln を直接ビルド
    risk_level: low
    related:
    - msbuild
    - msvc
    - cpp
    - testing
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# cmake

CMake による C++ プロジェクトの構成・ビルド

## When to Use
Trigger: CMake, CMakeLists.txt, CMakePresets, ビルド構成

## Tools
- required: terminal, read_file, patch
- optional: search_files
- dependencies: cmake, ninja（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. cmake --version と CMakePresets.json の有無を確認する
2. cmake --preset <name> または cmake -S . -B build -G "Ninja Multi-Config" で構成する
3. target_link_libraries / target_include_directories(PRIVATE/PUBLIC) でターゲット単位に依存を記述する
4. cmake --build build --config Debug -j で構築し ctest --test-dir build -C Debug を実行する
5. 依存は find_package(CONFIG) か vcpkg toolchain (-DCMAKE_TOOLCHAIN_FILE) で解決する

## Verification
cmake --build が成功し ctest が全件 pass

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. cmake 不在: winget install Kitware.CMake
2. Ninja 不在: winget install Ninja-build.Ninja か -G "Visual Studio 17 2022"
3. 構成キャッシュ破損: build ディレクトリを別名で新規作成して再構成
4. msbuild で .sln を直接ビルド

## Related
msbuild, msvc, cpp, testing

## Prohibited
- build ディレクトリ以外を削除しない
- グローバル CMAKE 変数を無断で恒久設定しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
