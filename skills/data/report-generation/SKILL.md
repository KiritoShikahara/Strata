---
name: report-generation
description: 分析結果のレポート（Markdown/HTML/PDF/docx）作成
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - data
    category: data
  kiridev:
    namespace: kiridev
    category: data
    triggers:
    - レポート
    - 報告書
    - 分析結果まとめ
    - PDF 出力
    - docx
    - 資料作成
    required_tools:
    - write_file
    - terminal
    optional_tools:
    - read_file
    - execute_code
    - vision_analyze
    dependencies:
    - pandoc
    - python-docx
    conflicts: []
    workflow: see '## Procedure'
    verification: 出力ファイルが開け、数値が元の分析結果と一致し、全図表に参照・出典がある
    fallback:
    - winget install JohnMacFarlane.Pandoc で導入
    - PDF 不可は HTML 出力→ブラウザ印刷、または python-docx で docx 生成
    - 日本語 PDF が崩れる場合は --pdf-engine=lualatex と日本語フォント指定
    risk_level: low
    related:
    - data-analysis
    - charting
    - spreadsheet
    - statistics
    - universal-document-ingestion
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# report-generation

分析結果のレポート（Markdown/HTML/PDF/docx）作成

## When to Use
Trigger: レポート, 報告書, 分析結果まとめ, PDF 出力, docx, 資料作成

## Tools
- required: write_file, terminal
- optional: read_file, execute_code, vision_analyze
- dependencies: pandoc, python-docx（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 読み手と目的を決め、結論→根拠→方法→限界→次アクションの順に構成する
2. 数値は分析コードから自動出力（表・グラフ）して転記ミスを防ぐ
3. Markdown で本文を作成し図表を相対パスで埋め込む
4. 変換: pandoc report.md -o report.docx（または --pdf-engine=xelatex / HTML は --standalone）
5. 出力を開いて体裁・文字化け・図表番号を確認する

## Verification
出力ファイルが開け、数値が元の分析結果と一致し、全図表に参照・出典がある

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. winget install JohnMacFarlane.Pandoc で導入
2. PDF 不可は HTML 出力→ブラウザ印刷、または python-docx で docx 生成
3. 日本語 PDF が崩れる場合は --pdf-engine=lualatex と日本語フォント指定

## Related
data-analysis, charting, spreadsheet, statistics, universal-document-ingestion

## Prohibited
- レポートのメール送信・共有・公開は承認なしで行わない
- 根拠のない数値や出典不明の引用を載せない
- Approval 対象（permission-policy 参照）は実行前に確認する。
