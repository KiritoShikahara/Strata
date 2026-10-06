---
name: asset-generation
description: 画像/音声などアセットの生成・変換・命名管理
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
    - 画像生成
    - アセット生成
    - テクスチャ生成
    - 音声合成
    - アイコン作成
    required_tools:
    - image_generate
    - terminal
    - write_file
    optional_tools:
    - vision_analyze
    - text_to_speech
    - read_file
    dependencies:
    - ffmpeg
    - ImageMagick
    conflicts: []
    workflow: see '## Procedure'
    verification: 指定の解像度/形式で出力され、vision_analyze 検査で破綻が無く出典メモがある
    fallback:
    - 生成不可なら既存素材の加工（ImageMagick）や手描きプレースホルダを作る
    - winget install ImageMagick.ImageMagick / Gyan.FFmpeg で導入
    - ライセンス確認済みの CC0 素材を research で探す
    risk_level: medium
    related:
    - creative-direction
    - 3d-pipeline
    - blender-assist
    - asset-pipeline
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# asset-generation

画像/音声などアセットの生成・変換・命名管理

## When to Use
Trigger: 画像生成, アセット生成, テクスチャ生成, 音声合成, アイコン作成

## Tools
- required: image_generate, terminal, write_file
- optional: vision_analyze, text_to_speech, read_file
- dependencies: ffmpeg, ImageMagick（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 用途・解像度・形式・透過有無・スタイルガイドを確認する
2. プロンプトに主題・スタイル・構図・禁止要素を書き image_generate で複数候補を生成する
3. vision_analyze で破綻（手/文字/タイリング）を検査し選別する
4. 後処理: magick in.png -resize 1024x1024 out.png、音声は ffmpeg -i で変換する
5. 命名規則（type_name_v01.png）で別フォルダへ保存し出典とプロンプトを記録する

## Verification
指定の解像度/形式で出力され、vision_analyze 検査で破綻が無く出典メモがある

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 生成不可なら既存素材の加工（ImageMagick）や手描きプレースホルダを作る
2. winget install ImageMagick.ImageMagick / Gyan.FFmpeg で導入
3. ライセンス確認済みの CC0 素材を research で探す

## Related
creative-direction, 3d-pipeline, blender-assist, asset-pipeline

## Prohibited
- 実在人物の肖像・著作物の無断再現を生成しない
- 有償 API の大量生成（課金）や生成物の外部公開は承認なしで行わない
- Approval 対象（permission-policy 参照）は実行前に確認する。
