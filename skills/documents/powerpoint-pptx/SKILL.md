---
name: powerpoint-pptx
description: PowerPoint(.pptx) のスライド・ノート・図の解析
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
    - pptx
    - PowerPoint
    - スライド
    - python-pptx
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - vision_analyze
    dependencies:
    - python-pptx
    conflicts: []
    workflow: see '## Procedure'
    verification: len(prs.slides) と出力したスライド数が一致、画像/図のあるスライドに言及がある
    fallback:
    - python-pptx 失敗 → ppt/slides/slideN.xml を直接解析
    - 'COM: New-Object -ComObject PowerPoint.Application で SaveAs PDF (ppSaveAsPDF=32)'
    - soffice --headless --convert-to pdf → pdftoppm -r 100 -png
    - ocr-fallback (tesseract) は最後
    risk_level: low
    related:
    - universal-document-ingestion
    - speaker-notes-analysis
    - smartart-analysis
    - chart-analysis
    - office-rendering
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# powerpoint-pptx

PowerPoint(.pptx) のスライド・ノート・図の解析

## When to Use
Trigger: pptx, PowerPoint, スライド, python-pptx

## Tools
- required: terminal, read_file
- optional: vision_analyze
- dependencies: python-pptx（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. python -I で pptx.Presentation(path) を開き slide.shapes の text_frame を列挙
2. slide.notes_slide.notes_text_frame.text でノートを取得（speaker-notes-analysis）
3. ppt/media, ppt/charts, ppt/diagrams を unzip で確認し画像・グラフ・SmartArt を把握
4. office-rendering で PDF→PNG 化し各スライドを vision_analyze
5. スライド番号付きで要約を出力

## Verification
len(prs.slides) と出力したスライド数が一致、画像/図のあるスライドに言及がある

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. python-pptx 失敗 → ppt/slides/slideN.xml を直接解析
2. COM: New-Object -ComObject PowerPoint.Application で SaveAs PDF (ppSaveAsPDF=32)
3. soffice --headless --convert-to pdf → pdftoppm -r 100 -png
4. ocr-fallback (tesseract) は最後

## Related
universal-document-ingestion, speaker-notes-analysis, smartart-analysis, chart-analysis, office-rendering

## Prohibited
- 画像があるから読めないと言わない
- 元ファイル上書き禁止
- スライド内容の外部送信禁止
- Approval 対象（permission-policy 参照）は実行前に確認する。
