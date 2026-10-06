---
name: c
description: C 言語のコード作成・ビルド・デバッグ
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
    - C言語
    - .c
    - gcc
    - ポインタ
    - malloc
    required_tools:
    - terminal
    - read_file
    - patch
    optional_tools:
    - search_files
    dependencies:
    - cl
    - gcc
    - clang
    conflicts: []
    workflow: see '## Procedure'
    verification: 警告 0 でビルドし ASan 下の実行でエラーなし
    fallback:
    - 'cl 不在: clang (winget install LLVM.LLVM)'
    - MSYS2 gcc (winget install MSYS2.MSYS2)
    - WSL gcc / Docker gcc
    risk_level: low
    related:
    - cpp
    - cmake
    - debugging
    - memory-performance
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# c

C 言語のコード作成・ビルド・デバッグ

## When to Use
Trigger: C言語, .c, gcc, ポインタ, malloc

## Tools
- required: terminal, read_file, patch
- optional: search_files
- dependencies: cl, gcc, clang（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. cl /TC /W4 /std:c17 file.c または clang -std=c17 -Wall -Wextra file.c でビルドする
2. 境界チェック・NULL チェック・戻り値確認を点検する
3. malloc/free の対応を確認し /fsanitize=address で検証する
4. strcpy 等は strncpy_s / snprintf に置換する
5. Makefile/CMake で再現可能なビルドにする

## Verification
警告 0 でビルドし ASan 下の実行でエラーなし

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. cl 不在: clang (winget install LLVM.LLVM)
2. MSYS2 gcc (winget install MSYS2.MSYS2)
3. WSL gcc / Docker gcc

## Related
cpp, cmake, debugging, memory-performance

## Prohibited
- gets/strcpy 等の危険関数を新規で使わない
- ASan 警告を無視しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
