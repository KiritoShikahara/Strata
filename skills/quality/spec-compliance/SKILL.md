---
name: spec-compliance
description: 実装が仕様・要件を満たすかを項目単位で照合
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
    - 仕様適合
    - 要件確認
    - 受け入れ基準
    - spec
    required_tools:
    - terminal
    - read_file
    - search_files
    optional_tools:
    - todo
    dependencies:
    - git
    conflicts: []
    workflow: see '## Procedure'
    verification: 全基準に判定と根拠 (コマンド出力 or file:line) が付いている
    fallback:
    - 仕様が曖昧 → 解釈案を明記して clarify
    - テスト不可 → 手動再現手順と結果を記録
    - rg 無し → Select-String -Recurse
    risk_level: low
    related:
    - verification
    - testing
    - code-review
    - artifact-validation
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# spec-compliance

実装が仕様・要件を満たすかを項目単位で照合

## When to Use
Trigger: 仕様適合, 要件確認, 受け入れ基準, spec

## Tools
- required: terminal, read_file, search_files
- optional: todo
- dependencies: git（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 仕様/Issue/依頼文から受け入れ基準を番号付きチェックリスト化 (todo)
2. git diff main...HEAD --stat で変更範囲を確認し各基準に対応コードを rg で特定
3. 各基準を実コマンド/テストで実行確認し 満たす/不足/未実装 に分類
4. 仕様外の変更（スコープ逸脱）も列挙
5. 結果表を file:line 付きで報告

## Verification
全基準に判定と根拠 (コマンド出力 or file:line) が付いている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 仕様が曖昧 → 解釈案を明記して clarify
2. テスト不可 → 手動再現手順と結果を記録
3. rg 無し → Select-String -Recurse

## Related
verification, testing, code-review, artifact-validation

## Prohibited
- 未確認の基準を満たすと報告しない
- 仕様を実装に合わせて書き換えない
- Approval 対象（permission-policy 参照）は実行前に確認する。
