---
name: csv-tsv
description: CSV/TSV の読み込み・変換・検証（文字コード/区切り対応）
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
    - CSV
    - TSV
    - 区切り文字
    - 文字化け
    - Shift_JIS
    - 変換
    required_tools:
    - terminal
    - execute_code
    optional_tools:
    - read_file
    - write_file
    dependencies:
    - pandas
    conflicts: []
    workflow: see '## Procedure'
    verification: 出力の行数が入力と一致（または意図した差）し、Excel/pandas で文字化け無く開ける
    fallback:
    - pip install pandas chardet で導入
    - 巨大ファイルは chunksize か Polars/DuckDB で処理
    - pandas 不可は標準 csv モジュール/Import-Csv
    risk_level: low
    related:
    - spreadsheet
    - data-cleaning
    - json
    - sqlite
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# csv-tsv

CSV/TSV の読み込み・変換・検証（文字コード/区切り対応）

## When to Use
Trigger: CSV, TSV, 区切り文字, 文字化け, Shift_JIS, 変換

## Tools
- required: terminal, execute_code
- optional: read_file, write_file
- dependencies: pandas（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Get-Content -TotalCount 5 .\f.csv と file/chardet で文字コード（UTF-8/BOM/cp932）と区切りを確認する
2. pandas.read_csv(p, encoding="cp932", sep=",", dtype=str) で型崩れを防いで読む
3. 行数・列数・欠損・重複キーを集計し壊れた行（引用符/改行）を特定する
4. 変換は to_csv(encoding="utf-8-sig", index=False) で別ファイルに出力する
5. 簡易処理は Import-Csv / Export-Csv -Encoding utf8 も使える

## Verification
出力の行数が入力と一致（または意図した差）し、Excel/pandas で文字化け無く開ける

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. pip install pandas chardet で導入
2. 巨大ファイルは chunksize か Polars/DuckDB で処理
3. pandas 不可は標準 csv モジュール/Import-Csv

## Related
spreadsheet, data-cleaning, json, sqlite

## Prohibited
- 入力ファイルを直接上書きしない
- 個人情報を含む CSV を外部送信しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
