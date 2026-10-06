---
name: ui-ux-generation
description: UI のワイヤー・モック・HTML/CSS 実装を生成する
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - multimodal
    category: multimodal
  kiridev:
    namespace: kiridev
    category: multimodal
    triggers:
    - UI作成
    - ワイヤーフレーム
    - モック
    - 画面デザイン
    - HTML/CSS
    required_tools:
    - write_file
    - read_file
    optional_tools:
    - browser_navigate
    - vision_analyze
    - image_generate
    dependencies:
    - node
    conflicts: []
    workflow: see '## Procedure'
    verification: ブラウザで崩れず表示され、主要画面が要件どおり揃っている
    fallback:
    - 既存プロジェクトがあればそのフレームワーク・デザイントークンに合わせる
    - ブラウザ確認不可は HTML 検証(npx html-validate)
    - 画像素材が必要なら image-generation か SVG で代替
    risk_level: low
    related:
    - ui-ux-analysis
    - image-generation
    - testing
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# ui-ux-generation

UI のワイヤー・モック・HTML/CSS 実装を生成する

## When to Use
Trigger: UI作成, ワイヤーフレーム, モック, 画面デザイン, HTML/CSS

## Tools
- required: write_file, read_file
- optional: browser_navigate, vision_analyze, image_generate
- dependencies: node（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 目的・ユーザー・主要画面・制約(ブランド色/レスポンシブ)を整理する
2. 構造を Mermaid か ASCII ワイヤーで示し、合意後 HTML/CSS(または既存フレームワーク)で実装
3. file:///<path>/index.html を browser_navigate で開き、スクショを vision_analyze で確認
4. ui-ux-analysis の基準(コントラスト・タップ領域)で修正する

## Verification
ブラウザで崩れず表示され、主要画面が要件どおり揃っている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 既存プロジェクトがあればそのフレームワーク・デザイントークンに合わせる
2. ブラウザ確認不可は HTML 検証(npx html-validate)
3. 画像素材が必要なら image-generation か SVG で代替

## Related
ui-ux-analysis, image-generation, testing

## Prohibited
- 既存ファイルを承認なしで大量上書きしない
- 外部 CDN の未検証スクリプトを埋め込まない
- Approval 対象（permission-policy 参照）は実行前に確認する。
