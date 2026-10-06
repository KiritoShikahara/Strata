---
name: cmd
description: cmd.exe とバッチファイルの実行・変換
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - system
    category: system
  kiridev:
    namespace: kiridev
    category: system
    triggers:
    - cmd
    - バッチ
    - .bat
    - cmd /c
    required_tools:
    - terminal
    optional_tools:
    - read_file
    - write_file
    dependencies:
    - cmd.exe
    conflicts: []
    workflow: see '## Procedure'
    verification: echo %ERRORLEVEL% が 0 で期待出力が得られる
    fallback:
    - PowerShell の Start-Process / & 演算子で呼ぶ
    - Git Bash 経由で実行
    - PowerShell スクリプトに書換える
    risk_level: low
    related:
    - powershell
    - filesystem
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# cmd

cmd.exe とバッチファイルの実行・変換

## When to Use
Trigger: cmd, バッチ, .bat, cmd /c

## Tools
- required: terminal
- optional: read_file, write_file
- dependencies: cmd.exe（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. cmd /c "<command>" で実行し %ERRORLEVEL% を確認する
2. where <exe> でパス解決を確認する
3. バッチは setlocal EnableDelayedExpansion と if errorlevel 1 exit /b 1 を使う
4. パスの空白は二重引用符で囲み、%~dp0 で自スクリプト基準にする
5. 複雑なら PowerShell へ移植する

## Verification
echo %ERRORLEVEL% が 0 で期待出力が得られる

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. PowerShell の Start-Process / & 演算子で呼ぶ
2. Git Bash 経由で実行
3. PowerShell スクリプトに書換える

## Related
powershell, filesystem

## Prohibited
- format / del /s /q / rd /s /q を承認なしで実行しない
- ユーザー入力を未エスケープで連結しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
