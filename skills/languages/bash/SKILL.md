---
name: bash
description: Bash スクリプト作成(Git Bash / WSL)と実行
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
    - bash
    - シェルスクリプト
    - .sh
    - WSL
    - Git Bash
    required_tools:
    - terminal
    - read_file
    - write_file
    optional_tools:
    - patch
    dependencies:
    - bash
    - shellcheck
    conflicts: []
    workflow: see '## Procedure'
    verification: shellcheck 指摘 0 で bash -n と実行が成功
    fallback:
    - 'bash 不在: winget install Git.Git (Git Bash)'
    - 'WSL: wsl --install'
    - PowerShell で等価処理を書く
    - Docker の bash/alpine イメージ
    risk_level: low
    related:
    - wsl-linux
    - powershell
    - filesystem
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# bash

Bash スクリプト作成(Git Bash / WSL)と実行

## When to Use
Trigger: bash, シェルスクリプト, .sh, WSL, Git Bash

## Tools
- required: terminal, read_file, write_file
- optional: patch
- dependencies: bash, shellcheck（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. bash --version と実行場所(Git Bash か wsl)を確認する
2. 先頭に #!/usr/bin/env bash と set -euo pipefail を置く
3. 変数は "$var" で必ずクォートし [[ ]] を使う
4. shellcheck script.sh で検査する(winget install koalaman.shellcheck)
5. Windows パスは cygpath -u / wslpath で変換し CRLF は dos2unix または sed で LF にする

## Verification
shellcheck 指摘 0 で bash -n と実行が成功

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. bash 不在: winget install Git.Git (Git Bash)
2. WSL: wsl --install
3. PowerShell で等価処理を書く
4. Docker の bash/alpine イメージ

## Related
wsl-linux, powershell, filesystem

## Prohibited
- rm -rf を変数展開(未検証)で実行しない
- curl | bash を実行しない
- eval で外部入力を実行しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
