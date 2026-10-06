---
name: dead-code-removal
description: 未使用コード・依存・ファイルを特定して安全に削除
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - quality
    category: quality
  kiridev:
    namespace: kiridev
    category: quality
    triggers:
    - デッドコード
    - 未使用
    - 不要コード
    - vulture
    - knip
    required_tools:
    - terminal
    - read_file
    - search_files
    optional_tools:
    - patch
    dependencies:
    - vulture
    - knip
    - depcheck
    conflicts: []
    workflow: see '## Procedure'
    verification: 削除後にテスト/ビルド/lint が通り、再スキャンで候補が減っている
    fallback:
    - vulture 無し → pip install vulture / ruff F401,F841
    - 判断不能 → 削除せず「要確認」として報告
    risk_level: medium
    related:
    - simplicity-yagni
    - checkpoint
    - git
    - test-coverage
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# dead-code-removal

未使用コード・依存・ファイルを特定して安全に削除

## When to Use
Trigger: デッドコード, 未使用, 不要コード, vulture, knip

## Tools
- required: terminal, read_file, search_files
- optional: patch
- dependencies: vulture, knip, depcheck（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Python: vulture src --min-confidence 80 ； JS: npx knip / npx depcheck
2. 候補を rg -n で全参照確認（動的参照・リフレクション・設定ファイル・エントリポイント含む）
3. git log -S で経緯確認し、削除前に checkpoint/ブランチを作成
4. 1種類ずつ削除し都度テスト・ビルド
5. 削除一覧と根拠を報告

## Verification
削除後にテスト/ビルド/lint が通り、再スキャンで候補が減っている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. vulture 無し → pip install vulture / ruff F401,F841
2. 判断不能 → 削除せず「要確認」として報告

## Related
simplicity-yagni, checkpoint, git, test-coverage

## Prohibited
- 大量ファイルの不可逆削除は承認が必要（git 管理下で復元可能にする）
- 公開 API/動的参照の可能性があるものを根拠なく消さない
- Approval 対象（permission-policy 参照）は実行前に確認する。
