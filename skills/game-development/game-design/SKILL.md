---
name: game-design
description: ゲームデザイン文書・コアループ・バランス設計
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - game-development
    category: game-development
  kiridev:
    namespace: kiridev
    category: game-development
    triggers:
    - ゲームデザイン
    - コアループ
    - GDD
    - バランス調整
    - 企画
    required_tools:
    - read_file
    - write_file
    optional_tools:
    - web_search
    - clarify
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: GDD にコアループ・数値表・MVP 範囲があり、プレイテスト項目が定義されている
    fallback:
    - 情報不足は clarify で質問、または前提置きで進める
    - 類似作品を research で分析して参考にする
    - 文書が重い場合は 1 ページのデザインピラーに縮約する
    risk_level: low
    related:
    - gameplay-systems
    - level-design
    - story-writing
    - research
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# game-design

ゲームデザイン文書・コアループ・バランス設計

## When to Use
Trigger: ゲームデザイン, コアループ, GDD, バランス調整, 企画

## Tools
- required: read_file, write_file
- optional: web_search, clarify
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 1 文のコンセプトとターゲット体験・プレイ時間を定義する
2. コアループ（行動→報酬→成長）とメタループを図示する
3. 主要メカニクスと数値（経済・難易度曲線）を表にし CSV で管理する
4. 最小プレイアブル範囲（MVP）を切り出し検証項目を決める
5. docs\GDD.md にまとめ、プレイテスト結果で更新する

## Verification
GDD にコアループ・数値表・MVP 範囲があり、プレイテスト項目が定義されている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 情報不足は clarify で質問、または前提置きで進める
2. 類似作品を research で分析して参考にする
3. 文書が重い場合は 1 ページのデザインピラーに縮約する

## Related
gameplay-systems, level-design, story-writing, research

## Prohibited
- 既存作品の素材・文章をそのまま流用しない（著作権）
- 外部への企画資料の送信・公開は承認なしで行わない
- Approval 対象（permission-policy 参照）は実行前に確認する。
