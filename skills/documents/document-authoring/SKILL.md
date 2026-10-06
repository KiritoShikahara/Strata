---
name: document-authoring
description: 新規文書(docx/pptx/xlsx/md)を構成から作成
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
    - 文書作成
    - 資料作成
    - レポート作成
    - 新規ドキュメント
    required_tools:
    - terminal
    - write_file
    optional_tools:
    - read_file
    - vision_analyze
    dependencies:
    - python-docx
    - python-pptx
    - openpyxl
    - pandoc
    conflicts: []
    workflow: see '## Procedure'
    verification: 再度読み込んで見出し・表・図の数を確認し、レンダリング画像で崩れがない
    fallback:
    - pandoc 無し → winget install JohnMacFarlane.Pandoc
    - python-docx 不可 → COM で作成
    - soffice で md/html → docx 変換
    risk_level: low
    related:
    - document-editing
    - office-rendering
    - word-docx
    - powerpoint-pptx
    - excel-xlsx
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# document-authoring

新規文書(docx/pptx/xlsx/md)を構成から作成

## When to Use
Trigger: 文書作成, 資料作成, レポート作成, 新規ドキュメント

## Tools
- required: terminal, write_file
- optional: read_file, vision_analyze
- dependencies: python-docx, python-pptx, openpyxl, pandoc（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 目的・読者・形式・分量を確認し見出し構成（アウトライン）を先に作成
2. Markdown 原稿を作成 → pandoc draft.md -o out.docx --reference-doc=tpl.docx
3. 細かい書式は python-docx / python-pptx / openpyxl で組み立て
4. office-rendering で PDF/画像化し見た目を確認
5. 出力先は指定フォルダ、既存ファイルがあれば別名で保存

## Verification
再度読み込んで見出し・表・図の数を確認し、レンダリング画像で崩れがない

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. pandoc 無し → winget install JohnMacFarlane.Pandoc
2. python-docx 不可 → COM で作成
3. soffice で md/html → docx 変換

## Related
document-editing, office-rendering, word-docx, powerpoint-pptx, excel-xlsx

## Prohibited
- 既存ファイルを無断上書きしない
- 作成物の外部送信・公開は承認なしにしない
- 出典のない数値・事実を捏造しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
