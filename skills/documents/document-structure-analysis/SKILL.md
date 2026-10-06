---
name: document-structure-analysis
description: 文書の見出し・章立て・表・図・参照構造を解析
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
    - 構造解析
    - 見出し
    - 目次
    - アウトライン
    - スタイル
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - vision_analyze
    dependencies:
    - python-docx
    conflicts: []
    workflow: see '## Procedure'
    verification: アウトラインの見出し数が styles 集計と一致、全表・図が一覧に含まれる
    fallback:
    - スタイル未使用 → フォントサイズ/太字から見出し推定（推定と明記）
    - pandoc a.docx -t json で AST 取得
    - office-rendering → vision で視覚的に章構造を判断
    risk_level: low
    related:
    - word-docx
    - table-reconstruction
    - document-editing
    - office-ooxml-inspection
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# document-structure-analysis

文書の見出し・章立て・表・図・参照構造を解析

## When to Use
Trigger: 構造解析, 見出し, 目次, アウトライン, スタイル

## Tools
- required: terminal, read_file
- optional: vision_analyze
- dependencies: python-docx（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. paragraph.style.name が Heading N のものを列挙しアウトライン化
2. document.xml の w:sectPr, w:tbl, w:drawing, w:fldSimple(TOC/REF) を集計
3. ヘッダ/フッタ・脚注 (footnotes.xml)・コメント (comments.xml) も確認
4. 表・図の番号とキャプションの対応表を作成
5. PPTX はスライドレイアウト、XLSX はシート依存関係を同様に整理

## Verification
アウトラインの見出し数が styles 集計と一致、全表・図が一覧に含まれる

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. スタイル未使用 → フォントサイズ/太字から見出し推定（推定と明記）
2. pandoc a.docx -t json で AST 取得
3. office-rendering → vision で視覚的に章構造を判断

## Related
word-docx, table-reconstruction, document-editing, office-ooxml-inspection

## Prohibited
- 推定した構造を確定事項として扱わない
- 元ファイル変更禁止
- Approval 対象（permission-policy 参照）は実行前に確認する。
