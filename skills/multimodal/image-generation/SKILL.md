---
name: image-generation
description: テキストから画像を生成する
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
    - 画像生成
    - 絵を描いて
    - image generate
    - イラスト
    required_tools:
    - image_generate
    optional_tools:
    - write_file
    - terminal
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 保存画像が存在し、要件(内容・サイズ)を満たす
    fallback:
    - 生成 provider 不可は別 provider/モデルへ切替
    - ローカル生成は ComfyUI/Stable Diffusion WebUI(要 GPU)を利用
    - 不可なら SVG/Pillow で図を手続き生成
    risk_level: medium
    related:
    - image-editing
    - ui-ux-generation
    - vision
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# image-generation

テキストから画像を生成する

## When to Use
Trigger: 画像生成, 絵を描いて, image generate, イラスト

## Tools
- required: image_generate
- optional: write_file, terminal
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 用途・構図・スタイル・サイズ・禁止要素を整理したプロンプトを作る
2. image_generate を実行し出力を outputs\images\ に保存
3. vision_analyze で意図との一致を確認し、プロンプトを修正して再生成
4. 採用画像のプロンプト・日時を横にメモとして記録

## Verification
保存画像が存在し、要件(内容・サイズ)を満たす

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 生成 provider 不可は別 provider/モデルへ切替
2. ローカル生成は ComfyUI/Stable Diffusion WebUI(要 GPU)を利用
3. 不可なら SVG/Pillow で図を手続き生成

## Related
image-editing, ui-ux-generation, vision

## Prohibited
- 実在人物・著作物の模倣や偽画像を生成しない
- 有料 API の大量生成を承認なしで行わない
- Approval 対象（permission-policy 参照）は実行前に確認する。
