---
name: code-review
description: 差分をバグ・設計・保守性の観点でレビュー
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
    - コードレビュー
    - レビュー
    - PR確認
    - diff確認
    required_tools:
    - terminal
    - read_file
    - search_files
    optional_tools:
    - delegate_task
    dependencies:
    - git
    conflicts: []
    workflow: see '## Procedure'
    verification: 全変更ファイルを読了し、指摘に file:line と根拠がある
    fallback:
    - git 無し → 差分ファイルを Compare-Object で比較
    - 大差分 → ファイル単位に分割し delegate_task
    - static-analysis の結果で補強
    risk_level: low
    related:
    - independent-review
    - static-analysis
    - testing
    - git
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# code-review

差分をバグ・設計・保守性の観点でレビュー

## When to Use
Trigger: コードレビュー, レビュー, PR確認, diff確認

## Tools
- required: terminal, read_file, search_files
- optional: delegate_task
- dependencies: git（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. git diff --stat; git diff -U5 で全差分を読む（git log --oneline -10 で意図確認）
2. 正しさ→エラー処理→境界値→セキュリティ→性能→可読性の順に確認
3. 呼び出し元/先を rg -n で追い、影響範囲とテスト有無を確認
4. 指摘を 重大/中/軽微 に分け file:line と修正案を付ける
5. 良い点も簡潔に記載

## Verification
全変更ファイルを読了し、指摘に file:line と根拠がある

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. git 無し → 差分ファイルを Compare-Object で比較
2. 大差分 → ファイル単位に分割し delegate_task
3. static-analysis の結果で補強

## Related
independent-review, static-analysis, testing, git

## Prohibited
- レビューのみで勝手にコードを修正しない
- 推測だけで重大指摘をしない
- PR への投稿・コメント送信は承認なしにしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
