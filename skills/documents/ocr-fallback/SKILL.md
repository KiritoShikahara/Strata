---
name: ocr-fallback
description: 他手段で読めない画像・スキャンを tesseract で OCR
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - documents
    category: documents
  kiridev:
    namespace: kiridev
    category: documents
    triggers:
    - OCR
    - tesseract
    - スキャン
    - 画像内文字
    - 文字認識
    required_tools:
    - terminal
    - vision_analyze
    optional_tools:
    - read_file
    dependencies:
    - tesseract
    - pytesseract
    conflicts: []
    workflow: see '## Procedure'
    verification: サンプル数行を目視/vision と照合し誤認識率を把握、出力ファイルが空でない
    fallback:
    - tesseract 無し → winget install UB-Mannheim.TesseractOCR
    - jpn 無し → tessdata に jpn.traineddata を追加
    - pip install easyocr / rapidocr-onnxruntime
    - Windows.Media.Ocr (PowerShell WinRT) / Docker の OCR イメージ
    risk_level: low
    related:
    - office-rendering
    - table-reconstruction
    - embedded-media-extraction
    - universal-document-ingestion
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# ocr-fallback

他手段で読めない画像・スキャンを tesseract で OCR

## When to Use
Trigger: OCR, tesseract, スキャン, 画像内文字, 文字認識

## Tools
- required: terminal, vision_analyze
- optional: read_file
- dependencies: tesseract, pytesseract（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Get-Command tesseract; tesseract --list-langs で jpn/eng を確認
2. 前処理: 300dpi 化（pdftoppm -r 300 -png）、グレースケール・二値化
3. tesseract in.png out -l jpn+eng --psm 6 （表は tsv 出力）
4. vision_analyze の結果と突合し、不一致箇所を明示
5. 信頼度の低い行 (conf<60) を要確認として報告

## Verification
サンプル数行を目視/vision と照合し誤認識率を把握、出力ファイルが空でない

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. tesseract 無し → winget install UB-Mannheim.TesseractOCR
2. jpn 無し → tessdata に jpn.traineddata を追加
3. pip install easyocr / rapidocr-onnxruntime
4. Windows.Media.Ocr (PowerShell WinRT) / Docker の OCR イメージ

## Related
office-rendering, table-reconstruction, embedded-media-extraction, universal-document-ingestion

## Prohibited
- 最初の手段として使わない（native→OOXML→レンダリング→vision の後）
- OCR 結果を無検証で断定しない
- 画像の外部 OCR サービス送信は承認なしにしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
