---
name: software-architecture
description: モジュール境界と依存方向を決めるアーキテクチャ設計
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - development
    category: development
  kiridev:
    namespace: kiridev
    category: development
    triggers:
    - アーキテクチャ
    - 設計方針
    - レイヤー
    - モジュール分割
    - ADR
    required_tools:
    - read_file
    - search_files
    - write_file
    optional_tools:
    - terminal
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: docs/adr に決定記録があり、依存方向が循環していない（madge/import-linter 等で確認）
    fallback:
    - 既存コードの grep で依存関係を手動集計する
    - PlantUML/Mermaid が使えなければ Markdown 表で代用
    - 判断が難しければ system-design/research で事例を調べる
    risk_level: low
    related:
    - system-design
    - requirements-analysis
    - refactoring
    - research
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# software-architecture

モジュール境界と依存方向を決めるアーキテクチャ設計

## When to Use
Trigger: アーキテクチャ, 設計方針, レイヤー, モジュール分割, ADR

## Tools
- required: read_file, search_files, write_file
- optional: terminal
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Get-ChildItem -Recurse -Directory で現行構成を把握し主要エントリポイントを読む
2. 品質特性（性能・保守性・変更容易性）の優先順位を明文化する
3. モジュール境界と依存方向を図（Mermaid）で docs/architecture.md に書く
4. 選択肢ごとにトレードオフを比較し docs/adr/NNNN-title.md に ADR として残す
5. 最小の縦切り（walking skeleton）で設計を検証する

## Verification
docs/adr に決定記録があり、依存方向が循環していない（madge/import-linter 等で確認）

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 既存コードの grep で依存関係を手動集計する
2. PlantUML/Mermaid が使えなければ Markdown 表で代用
3. 判断が難しければ system-design/research で事例を調べる

## Related
system-design, requirements-analysis, refactoring, research

## Prohibited
- 要件根拠なく大規模再設計・全面書き換えを始めない
- 外部有償サービスの契約・購入は承認なしで決めない
- Approval 対象（permission-policy 参照）は実行前に確認する。
