---
name: office-rendering
description: Office 文書を PDF/画像へ描画して視覚的に確認
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
    - PDF化
    - レンダリング
    - 画像化
    - pdftoppm
    - 見た目
    required_tools:
    - terminal
    - vision_analyze
    optional_tools:
    - read_file
    dependencies:
    - pdftoppm
    - PyMuPDF
    - soffice
    conflicts: []
    workflow: see '## Procedure'
    verification: ページ数と PNG 枚数が一致、vision 結果に図表の記述がある
    fallback:
    - COM 不可 → soffice --headless --convert-to pdf --outdir out a.docx
    - pdftoppm 無し → PyMuPDF (pip install pymupdf)
    - pandoc → PDF（要 LaTeX）/ HTML 化してブラウザで描画
    - 最後に ocr-fallback
    risk_level: low
    related:
    - office-native-automation
    - ocr-fallback
    - universal-document-ingestion
    - document-structure-analysis
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# office-rendering

Office 文書を PDF/画像へ描画して視覚的に確認

## When to Use
Trigger: PDF化, レンダリング, 画像化, pdftoppm, 見た目

## Tools
- required: terminal, vision_analyze
- optional: read_file
- dependencies: pdftoppm, PyMuPDF, soffice（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. COM の ExportAsFixedFormat で PDF 化（office-native-automation）
2. pdftoppm -r 120 -png a.pdf $env:TEMP\render\p で画像化
3. PyMuPDF: python -I -c "import fitz;d=fitz.open(p);d[0].get_pixmap(dpi=120).save(o)"
4. vision_analyze で各ページ画像を解析（図・表・レイアウト）
5. テキスト層が必要なら pdftotext -layout で補完

## Verification
ページ数と PNG 枚数が一致、vision 結果に図表の記述がある

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. COM 不可 → soffice --headless --convert-to pdf --outdir out a.docx
2. pdftoppm 無し → PyMuPDF (pip install pymupdf)
3. pandoc → PDF（要 LaTeX）/ HTML 化してブラウザで描画
4. 最後に ocr-fallback

## Related
office-native-automation, ocr-fallback, universal-document-ingestion, document-structure-analysis

## Prohibited
- 出力は専用の一時ディレクトリへ
- 元ファイル上書き禁止
- レンダリング画像の外部アップロード禁止
- Approval 対象（permission-policy 参照）は実行前に確認する。
