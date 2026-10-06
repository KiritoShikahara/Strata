---
name: wsl-linux
description: WSL2 の Linux 環境操作とファイル連携
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
    - WSL
    - wsl.exe
    - Ubuntu
    - Linux
    required_tools:
    - terminal
    optional_tools: []
    dependencies:
    - wsl.exe
    conflicts: []
    workflow: see '## Procedure'
    verification: wsl -d <distro> -- uname -a が成功
    fallback:
    - wsl --update / wsl --shutdown 後に再試行
    - '仮想化無効: BIOS と Get-ComputerInfo の HyperV 要件を確認'
    - Git Bash / Docker コンテナで代替
    risk_level: medium
    related:
    - docker
    - powershell
    - filesystem
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# wsl-linux

WSL2 の Linux 環境操作とファイル連携

## When to Use
Trigger: WSL, wsl.exe, Ubuntu, Linux

## Tools
- required: terminal
- optional: -
- dependencies: wsl.exe（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. wsl -l -v で distro とバージョンを確認する
2. wsl -d <distro> -- bash -lc "<cmd>" でコマンドを実行する
3. Windows パスは wslpath -u "C:\path"、WSL 側は \\wsl$\<distro>\ で参照する
4. I/O 性能のため作業は WSL 側ファイルシステム(~/)に置く
5. 導入は wsl --install -d Ubuntu(管理者・再起動が必要な場合あり)

## Verification
wsl -d <distro> -- uname -a が成功

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. wsl --update / wsl --shutdown 後に再試行
2. 仮想化無効: BIOS と Get-ComputerInfo の HyperV 要件を確認
3. Git Bash / Docker コンテナで代替

## Related
docker, powershell, filesystem

## Prohibited
- wsl --unregister を承認なしで実行しない(distro データ全消失)
- システム設定(.wslconfig)を無断変更しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
