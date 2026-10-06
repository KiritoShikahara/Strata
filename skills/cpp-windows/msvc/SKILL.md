---
name: msvc
description: MSVC (cl/link) コンパイラ・リンカの利用と診断
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
    - MSVC
    - cl.exe
    - link.exe
    - /std:c++20
    - LNK
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - patch
    dependencies:
    - cl
    - link
    - vswhere
    conflicts: []
    workflow: see '## Procedure'
    verification: cl が警告・エラー 0 で終了し実行ファイルが起動する
    fallback:
    - 'cl 不在: winget install Microsoft.VisualStudio.2022.BuildTools (C++ workload)'
    - clang-cl (winget install LLVM.LLVM)
    - MinGW-w64 で代替ビルド
    - cmake 経由で構成
    risk_level: low
    related:
    - cmake
    - msbuild
    - cpp
    - memory-performance
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# msvc

MSVC (cl/link) コンパイラ・リンカの利用と診断

## When to Use
Trigger: MSVC, cl.exe, link.exe, /std:c++20, LNK

## Tools
- required: terminal, read_file
- optional: patch
- dependencies: cl, link, vswhere（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Developer PowerShell (Launch-VsDevShell.ps1 -Arch amd64) で環境を読み込む
2. cl /nologo /EHsc /std:c++20 /W4 /permissive- /Zi main.cpp /link /DEBUG で試験ビルドする
3. LNK2019/2001 は dumpbin /symbols /exports と lib 順序・/MD /MT 不一致で調べる
4. 最適化は /O2 /GL /LTCG、診断は /analyze を使う
5. PDB 生成(/Zi)と /fsanitize=address を必要に応じ有効にする

## Verification
cl が警告・エラー 0 で終了し実行ファイルが起動する

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. cl 不在: winget install Microsoft.VisualStudio.2022.BuildTools (C++ workload)
2. clang-cl (winget install LLVM.LLVM)
3. MinGW-w64 で代替ビルド
4. cmake 経由で構成

## Related
cmake, msbuild, cpp, memory-performance

## Prohibited
- 警告を /w で一括抑制して隠さない
- ランタイム(/MD と /MT)を混在させない
- Approval 対象（permission-policy 参照）は実行前に確認する。
