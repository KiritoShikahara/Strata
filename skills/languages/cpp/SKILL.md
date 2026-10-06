---
name: cpp
description: C++ (C++17/20) のコード作成・ビルド・デバッグ
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
    - C++
    - cpp
    - .cpp
    - 'std:': null
    - テンプレート
    required_tools:
    - terminal
    - read_file
    - patch
    optional_tools:
    - search_files
    dependencies:
    - cl
    - clang++
    - cmake
    conflicts: []
    workflow: see '## Procedure'
    verification: cmake --build が警告 0 で成功し ctest が全件 pass
    fallback:
    - 'cl 不在: VS Build Tools を winget install Microsoft.VisualStudio.2022.BuildTools で導入し Developer PowerShell を使う'
    - clang++ / MinGW (winget install LLVM.LLVM)
    - WSL の g++ でビルド
    - Docker の gcc イメージ
    risk_level: low
    related:
    - cmake
    - msvc
    - c
    - memory-performance
    - debugging
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# cpp

C++ (C++17/20) のコード作成・ビルド・デバッグ

## When to Use
Trigger: C++, cpp, .cpp, {'std:': None}, テンプレート

## Tools
- required: terminal, read_file, patch
- optional: search_files
- dependencies: cl, clang++, cmake（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Get-Command cl, clang++, g++ で利用可能なコンパイラを確認する
2. CMakeLists.txt の CMAKE_CXX_STANDARD と警告設定(/W4 /permissive- または -Wall -Wextra)を確認する
3. cmake -S . -B build -G Ninja && cmake --build build で構築する
4. RAII/スマートポインタ/constexpr を優先し、生 new/delete を避けて修正する
5. AddressSanitizer (/fsanitize=address) や clang-tidy で検証する

## Verification
cmake --build が警告 0 で成功し ctest が全件 pass

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. cl 不在: VS Build Tools を winget install Microsoft.VisualStudio.2022.BuildTools で導入し Developer PowerShell を使う
2. clang++ / MinGW (winget install LLVM.LLVM)
3. WSL の g++ でビルド
4. Docker の gcc イメージ

## Related
cmake, msvc, c, memory-performance, debugging

## Prohibited
- 未検証のサードパーティバイナリをリンクしない
- UB を警告抑制だけで隠さない
- Approval 対象（permission-policy 参照）は実行前に確認する。
