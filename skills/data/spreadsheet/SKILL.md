---
name: spreadsheet
description: Excel/スプレッドシート（xlsx）の読み書き・数式・集計
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
    - Excel
    - xlsx
    - スプレッドシート
    - ピボット
    - 数式
    - シート
    required_tools:
    - terminal
    - read_file
    - execute_code
    optional_tools:
    - write_file
    dependencies:
    - openpyxl
    - pandas
    conflicts: []
    workflow: see '## Procedure'
    verification: 保存したファイルを再読込でき、行数/合計が元データと突合して一致する
    fallback:
    - openpyxl 不可なら xlsxwriter（新規作成）や pandas.to_excel
    - Excel が入っていれば PowerShell の COM（New-Object -ComObject Excel.Application）
    - CSV に変換して処理し、最後に xlsx へ戻す
    risk_level: low
    related:
    - csv-tsv
    - data-analysis
    - charting
    - report-generation
    - universal-document-ingestion
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# spreadsheet

Excel/スプレッドシート（xlsx）の読み書き・数式・集計

## When to Use
Trigger: Excel, xlsx, スプレッドシート, ピボット, 数式, シート

## Tools
- required: terminal, read_file, execute_code
- optional: write_file
- dependencies: openpyxl, pandas（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 原本は Copy-Item で作業用コピーを作り、コピー側のみ編集する
2. python -c "import openpyxl" で導入確認し、無ければ pip install openpyxl pandas
3. 構造把握: openpyxl.load_workbook(p, data_only=False) でシート名・範囲・数式を列挙する
4. 編集は pandas で集計/openpyxl でセル・書式・数式を書き込み、別名で保存する
5. 再読込して値・数式・結合セルが保たれているか確認する

## Verification
保存したファイルを再読込でき、行数/合計が元データと突合して一致する

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. openpyxl 不可なら xlsxwriter（新規作成）や pandas.to_excel
2. Excel が入っていれば PowerShell の COM（New-Object -ComObject Excel.Application）
3. CSV に変換して処理し、最後に xlsx へ戻す

## Related
csv-tsv, data-analysis, charting, report-generation, universal-document-ingestion

## Prohibited
- 原本の上書き・マクロ付き（.xlsm）の無確認実行をしない
- 機密データを外部サービスへ送信しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
