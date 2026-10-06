---
name: image-editing
description: 画像のリサイズ・切抜き・変換・注釈を行う
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
    - 画像編集
    - リサイズ
    - トリミング
    - 変換
    - 透過
    required_tools:
    - terminal
    optional_tools:
    - vision_analyze
    - execute_code
    dependencies:
    - magick
    - Pillow
    conflicts: []
    workflow: see '## Procedure'
    verification: 出力の寸法・形式が指定どおりで、元ファイルは無変更
    fallback:
    - magick 不在は winget install ImageMagick.ImageMagick
    - ImageMagick 不可は pip install pillow で代替
    - GUI 要件は Paint.NET/GIMP を winget 導入して案内
    risk_level: low
    related:
    - image-analysis
    - image-generation
    - filesystem
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# image-editing

画像のリサイズ・切抜き・変換・注釈を行う

## When to Use
Trigger: 画像編集, リサイズ, トリミング, 変換, 透過

## Tools
- required: terminal
- optional: vision_analyze, execute_code
- dependencies: magick, Pillow（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 元画像を別名コピーし編集は複製に対して行う
2. magick <in> -resize 1280x -quality 85 <out> や Pillow の crop/resize/convert で加工
3. 注釈は ImageDraw か magick -draw/-annotate で追加する
4. 出力を vision_analyze と Get-Item で確認する

## Verification
出力の寸法・形式が指定どおりで、元ファイルは無変更

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. magick 不在は winget install ImageMagick.ImageMagick
2. ImageMagick 不可は pip install pillow で代替
3. GUI 要件は Paint.NET/GIMP を winget 導入して案内

## Related
image-analysis, image-generation, filesystem

## Prohibited
- 元画像を上書きしない
- 画像の偽造・改ざん目的の加工をしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
