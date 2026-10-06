---
name: package-management
description: winget/choco/scoop/pip/npm によるパッケージ管理
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
    - winget
    - choco
    - scoop
    - パッケージ
    - インストール済み
    required_tools:
    - terminal
    optional_tools:
    - web_search
    dependencies:
    - winget
    conflicts: []
    workflow: see '## Procedure'
    verification: winget list --id <id> に表示され Get-Command <exe> が成功する
    fallback:
    - 'winget 不在: Microsoft Store の App Installer を案内'
    - choco install / scoop install に切替
    - 公式ポータブル zip を新規ディレクトリに展開
    - WSL の apt を使う
    risk_level: medium
    related:
    - software-installation
    - environment-variables
    - supply-chain-review
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# package-management

winget/choco/scoop/pip/npm によるパッケージ管理

## When to Use
Trigger: winget, choco, scoop, パッケージ, インストール済み

## Tools
- required: terminal
- optional: web_search
- dependencies: winget（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. winget search <name> で ID を特定し winget show <id> で提供元を確認する
2. winget list で導入済みと版を確認する
3. winget install --id <id> -e --source winget で導入する
4. winget upgrade --all は一覧を提示してから個別に実行する
5. 導入後に Get-Command で解決を確認する

## Verification
winget list --id <id> に表示され Get-Command <exe> が成功する

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. winget 不在: Microsoft Store の App Installer を案内
2. choco install / scoop install に切替
3. 公式ポータブル zip を新規ディレクトリに展開
4. WSL の apt を使う

## Related
software-installation, environment-variables, supply-chain-review

## Prohibited
- 未検証ソース/ミラーから導入しない
- 承認なしで全パッケージ一括更新しない
- 有償ソフトの購入・ライセンス登録を承認なしで行わない
- Approval 対象（permission-policy 参照）は実行前に確認する。
