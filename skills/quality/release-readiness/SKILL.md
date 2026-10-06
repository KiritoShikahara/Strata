---
name: release-readiness
description: リリース前チェック（テスト・版・変更履歴・成果物）
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
    - リリース準備
    - リリース前
    - 出荷判定
    - リリースチェック
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - todo
    dependencies:
    - git
    conflicts: []
    workflow: see '## Procedure'
    verification: チェックリスト全項目に pass/fail と証跡があり、Go/No-Go が明示されている
    fallback:
    - CI 無し → ローカル全コマンドで代替し記録
    - クリーン環境不可 → 新規 venv / Docker / WSL
    risk_level: medium
    related:
    - verification
    - artifact-validation
    - regression-testing
    - static-analysis
    - git
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# release-readiness

リリース前チェック（テスト・版・変更履歴・成果物）

## When to Use
Trigger: リリース準備, リリース前, 出荷判定, リリースチェック

## Tools
- required: terminal, read_file
- optional: todo
- dependencies: git（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. git status --porcelain が空、対象ブランチ・タグ・バージョン番号 (pyproject/package.json) を確認
2. テスト・lint・型・ビルドを全実行（regression-testing, lint-typecheck）
3. CHANGELOG/README/移行手順の更新を確認、静的解析で脆弱性・シークレット確認
4. ビルド成果物をクリーン環境で起動検証 (artifact-validation)
5. Go/No-Go を根拠付きで報告

## Verification
チェックリスト全項目に pass/fail と証跡があり、Go/No-Go が明示されている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. CI 無し → ローカル全コマンドで代替し記録
2. クリーン環境不可 → 新規 venv / Docker / WSL

## Related
verification, artifact-validation, regression-testing, static-analysis, git

## Prohibited
- publish / push / タグ付け / リリース公開は承認なしに実行しない
- 失敗項目を除外して Go にしない
- 認証情報を出力しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
