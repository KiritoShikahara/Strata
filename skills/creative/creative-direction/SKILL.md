---
name: creative-direction
description: ビジュアル/世界観の方向性決定とスタイルガイド作成
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - creative
    category: creative
  kiridev:
    namespace: kiridev
    category: creative
    triggers:
    - 世界観
    - アートディレクション
    - スタイルガイド
    - ムードボード
    - コンセプト
    required_tools:
    - read_file
    - write_file
    optional_tools:
    - web_search
    - vision_analyze
    - image_generate
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: スタイルガイドにパレット・禁止事項・参照例があり、代表画像が方針と一致している
    fallback:
    - 画像生成が使えなければ参照画像とテキスト記述でガイド化
    - ライセンス不明の参照は構造のみ抽出して使う
    - 選択に迷えば 2–3 案を比較表で提示する
    risk_level: low
    related:
    - asset-generation
    - game-design
    - story-writing
    - 3d-pipeline
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# creative-direction

ビジュアル/世界観の方向性決定とスタイルガイド作成

## When to Use
Trigger: 世界観, アートディレクション, スタイルガイド, ムードボード, コンセプト

## Tools
- required: read_file, write_file
- optional: web_search, vision_analyze, image_generate
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 目的・ターゲット・感情的ゴールを 3 つのキーワードに絞る
2. 参照資料を収集し、色・形・質感・光の方針を言語化する
3. カラーパレット（HEX）・フォント・シルエット規則を docs\style-guide.md に定義する
4. 代表シーン 1–2 枚（image_generate またはラフ）で方向性を検証する
5. 採用/不採用の理由を記録し制作側へ共有可能な形にする

## Verification
スタイルガイドにパレット・禁止事項・参照例があり、代表画像が方針と一致している

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 画像生成が使えなければ参照画像とテキスト記述でガイド化
2. ライセンス不明の参照は構造のみ抽出して使う
3. 選択に迷えば 2–3 案を比較表で提示する

## Related
asset-generation, game-design, story-writing, 3d-pipeline

## Prohibited
- 特定作家/IP の模倣・無断流用をしない
- 外部サービスへの機密企画資料のアップロードや課金は承認なしで行わない
- Approval 対象（permission-policy 参照）は実行前に確認する。
