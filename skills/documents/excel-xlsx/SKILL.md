---
name: excel-xlsx
description: Excel(.xlsx) のシート・数式・グラフ・表の読取
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
    - xlsx
    - Excel
    - エクセル
    - openpyxl
    - シート
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - execute_code
    dependencies:
    - openpyxl
    - pandas
    conflicts: []
    workflow: see '## Procedure'
    verification: 各シートの行数・列数と抽出結果が一致、数式セル数が報告に含まれる
    fallback:
    - openpyxl 失敗 → xl/worksheets/sheetN.xml と sharedStrings.xml を直接解析
    - 'COM: Excel.Application で SaveAs CSV / PDF 出力'
    - soffice --headless --convert-to csv / pdf
    - pandas + calamine エンジン (python-calamine)
    risk_level: low
    related:
    - universal-document-ingestion
    - chart-analysis
    - table-reconstruction
    - office-ooxml-inspection
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# excel-xlsx

Excel(.xlsx) のシート・数式・グラフ・表の読取

## When to Use
Trigger: xlsx, Excel, エクセル, openpyxl, シート

## Tools
- required: terminal, read_file
- optional: execute_code
- dependencies: openpyxl, pandas（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. python -I -c "import openpyxl;wb=openpyxl.load_workbook(p,data_only=False);print(wb.sheetnames)" で構成確認
2. 数式は data_only=False、計算値は data_only=True で二重に読む
3. 結合セル・非表示シート・名前定義・条件付き書式を確認
4. xl/charts, xl/drawings, xl/media を unzip で確認（chart-analysis）
5. 大表は pandas.read_excel(sheet_name=None) で要約

## Verification
各シートの行数・列数と抽出結果が一致、数式セル数が報告に含まれる

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. openpyxl 失敗 → xl/worksheets/sheetN.xml と sharedStrings.xml を直接解析
2. COM: Excel.Application で SaveAs CSV / PDF 出力
3. soffice --headless --convert-to csv / pdf
4. pandas + calamine エンジン (python-calamine)

## Related
universal-document-ingestion, chart-analysis, table-reconstruction, office-ooxml-inspection

## Prohibited
- 元ブックに保存しない（読取専用で開く）
- マクロ(.xlsm)を自動実行しない
- 機密データの外部送信禁止
- Approval 対象（permission-policy 参照）は実行前に確認する。
