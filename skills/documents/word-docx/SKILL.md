---
name: word-docx
description: Word(.docx) の読取・解析（python-docx→OOXML→COM の順）
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
    - docx
    - Word
    - ワード文書
    - python-docx
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - vision_analyze
    - write_file
    dependencies:
    - python-docx
    - pandoc
    conflicts: []
    workflow: see '## Procedure'
    verification: 段落数・表数・画像数 (word/media 件数) が抽出結果と一致することを確認
    fallback:
    - python-docx 失敗 → 拡張子を .zip にして Expand-Archive し word/document.xml を解析
    - COM (Word.Application) で ExportAsFixedFormat により PDF 化 → pdftoppm → vision
    - soffice --headless --convert-to pdf / pandoc a.docx -t markdown
    - 最後に ocr-fallback（OCR は最初の手段にしない）
    risk_level: low
    related:
    - universal-document-ingestion
    - office-ooxml-inspection
    - office-rendering
    - document-structure-analysis
    - fallback
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# word-docx

Word(.docx) の読取・解析（python-docx→OOXML→COM の順）

## When to Use
Trigger: docx, Word, ワード文書, python-docx

## Tools
- required: terminal, read_file
- optional: vision_analyze, write_file
- dependencies: python-docx, pandoc（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. python -I -c "import docx;d=docx.Document(r'C:\path\a.docx');print([p.text for p in d.paragraphs])" で本文・表を取得
2. 画像・図形・SmartArt が含まれるなら office-ooxml-inspection で word/document.xml, word/media, word/_rels を直接確認
3. 埋め込み画像は embedded-media-extraction で取り出し vision_analyze で内容把握
4. まだ不足なら office-rendering で PDF 化して画像として見る
5. 抽出結果を見出し・表・図の単位で整理して報告

## Verification
段落数・表数・画像数 (word/media 件数) が抽出結果と一致することを確認

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. python-docx 失敗 → 拡張子を .zip にして Expand-Archive し word/document.xml を解析
2. COM (Word.Application) で ExportAsFixedFormat により PDF 化 → pdftoppm → vision
3. soffice --headless --convert-to pdf / pandoc a.docx -t markdown
4. 最後に ocr-fallback（OCR は最初の手段にしない）

## Related
universal-document-ingestion, office-ooxml-inspection, office-rendering, document-structure-analysis, fallback

## Prohibited
- 「画像が含まれるので読めない」と回答しない
- 元ファイルを上書きしない（コピーで作業）
- 機密文書内容を外部サービスへ送信しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
