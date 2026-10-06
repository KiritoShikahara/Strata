---
name: image-analysis
description: 画像の詳細分析(OCR・属性・差分・メタデータ)
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
    - 画像分析
    - OCR
    - EXIF
    - 画像比較
    required_tools:
    - vision_analyze
    - terminal
    optional_tools:
    - execute_code
    dependencies:
    - python
    - Pillow
    - tesseract
    conflicts: []
    workflow: see '## Procedure'
    verification: OCR 文字列と視覚解析が整合し、数値・サイズが実測値と一致
    fallback:
    - tesseract 不在は winget install UB-Mannheim.TesseractOCR
    - Pillow 不在は pip install pillow
    - OCR 精度不足は二値化・拡大前処理か vision_analyze に任せる
    risk_level: low
    related:
    - vision
    - screenshot-analysis
    - diagram-analysis
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# image-analysis

画像の詳細分析(OCR・属性・差分・メタデータ)

## When to Use
Trigger: 画像分析, OCR, EXIF, 画像比較

## Tools
- required: vision_analyze, terminal
- optional: execute_code
- dependencies: python, Pillow, tesseract（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. メタデータ確認: python -c "from PIL import Image;im=Image.open(r\"<p>\");print(im.size,im.mode,im.getexif())"
2. vision_analyze で全体説明、領域指定の質問で詳細を取得
3. 文字は tesseract <img> stdout -l jpn+eng で OCR し視覚結果と照合
4. 差分は ImageChops.difference で比較し変化領域を報告

## Verification
OCR 文字列と視覚解析が整合し、数値・サイズが実測値と一致

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. tesseract 不在は winget install UB-Mannheim.TesseractOCR
2. Pillow 不在は pip install pillow
3. OCR 精度不足は二値化・拡大前処理か vision_analyze に任せる

## Related
vision, screenshot-analysis, diagram-analysis

## Prohibited
- EXIF の位置情報等を外部へ送らない
- 個人を特定する分析をしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
