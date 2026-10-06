---
name: office-ooxml-inspection
description: OOXML(zip) を直接展開して document.xml/rels/media を調査
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
    - OOXML
    - unzip
    - document.xml
    - _rels
    - 展開
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - search_files
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: Get-ChildItem -Recurse out で一覧化し、rels の参照先が全て実在することを確認
    fallback:
    - Expand-Archive 失敗 → python -I -m zipfile -e a.docx out
    - 7z x a.docx（7-Zip を winget install 7zip.7zip）
    - 破損時は zip 構造修復を試さず office-native-automation / office-rendering へ
    risk_level: low
    related:
    - word-docx
    - powerpoint-pptx
    - excel-xlsx
    - embedded-media-extraction
    - smartart-analysis
    - chart-analysis
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# office-ooxml-inspection

OOXML(zip) を直接展開して document.xml/rels/media を調査

## When to Use
Trigger: OOXML, unzip, document.xml, _rels, 展開

## Tools
- required: terminal, read_file
- optional: search_files
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. New-Item -ItemType Directory $env:TEMP\ooxml_x; Copy-Item a.docx $env:TEMP\ooxml_x\a.zip
2. Expand-Archive $env:TEMP\ooxml_x\a.zip -DestinationPath $env:TEMP\ooxml_x\out
3. [Content_Types].xml と word|ppt|xl/_rels/*.rels で関係（画像・chart・diagram）を把握
4. word/document.xml の w:t / a:t を抽出、word/media・drawings・charts・diagrams を列挙
5. diagrams/data*.xml は SmartArt、charts/chart*.xml はグラフとして各 skill へ

## Verification
Get-ChildItem -Recurse out で一覧化し、rels の参照先が全て実在することを確認

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. Expand-Archive 失敗 → python -I -m zipfile -e a.docx out
2. 7z x a.docx（7-Zip を winget install 7zip.7zip）
3. 破損時は zip 構造修復を試さず office-native-automation / office-rendering へ

## Related
word-docx, powerpoint-pptx, excel-xlsx, embedded-media-extraction, smartart-analysis, chart-analysis

## Prohibited
- 展開は専用の空ディレクトリで行う（作業ディレクトリ外）
- 展開物内のスクリプト/マクロを実行しない
- 元ファイルを書き換えない
- Approval 対象（permission-policy 参照）は実行前に確認する。
