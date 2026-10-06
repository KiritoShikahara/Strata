---
name: table-reconstruction
description: 文書・画像・PDF 内の表を構造化データ(CSV/表)へ復元
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
    - 表抽出
    - テーブル
    - 表復元
    - 結合セル
    - CSV化
    required_tools:
    - terminal
    - vision_analyze
    optional_tools:
    - read_file
    dependencies:
    - pandas
    - python-docx
    - camelot
    - pdfplumber
    conflicts: []
    workflow: see '## Procedure'
    verification: 行数・列数と合計/小計が原表と一致、結合セルの値が欠落していない
    fallback:
    - native 抽出不可 → OOXML の w:tbl を直接解析
    - pdfplumber 不可 → PyMuPDF page.find_tables()
    - vision → OCR (tesseract) → 手動確認が必要な箇所を明示
    risk_level: low
    related:
    - excel-xlsx
    - ocr-fallback
    - chart-analysis
    - document-structure-analysis
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# table-reconstruction

文書・画像・PDF 内の表を構造化データ(CSV/表)へ復元

## When to Use
Trigger: 表抽出, テーブル, 表復元, 結合セル, CSV化

## Tools
- required: terminal, vision_analyze
- optional: read_file
- dependencies: pandas, python-docx, camelot, pdfplumber（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. docx/pptx は native API（doc.tables / shape.table）でセル行列を取得、結合セル(gridSpan/vMerge)を展開
2. xlsx は pandas.read_excel(header=None) で生データのまま読む
3. PDF は pdfplumber page.extract_tables()、失敗時 camelot
4. 画像は office-rendering→vision で行列化、最後に tesseract --psm 6 tsv
5. CSV (UTF-8 BOM) に保存し行列数・合計値を原表と照合

## Verification
行数・列数と合計/小計が原表と一致、結合セルの値が欠落していない

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. native 抽出不可 → OOXML の w:tbl を直接解析
2. pdfplumber 不可 → PyMuPDF page.find_tables()
3. vision → OCR (tesseract) → 手動確認が必要な箇所を明示

## Related
excel-xlsx, ocr-fallback, chart-analysis, document-structure-analysis

## Prohibited
- OCR 結果を未検証で数値確定しない
- 元ファイル変更禁止
- Approval 対象（permission-policy 参照）は実行前に確認する。
