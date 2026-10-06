---
name: data-cleaning
description: 欠損・重複・表記ゆれ・型の整形（クレンジング）
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
    - データクレンジング
    - 欠損値
    - 重複
    - 表記ゆれ
    - 正規化
    - 外れ値
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
    verification: 整形後の期待制約（キー一意・型・範囲）を assert で確認でき、行数の増減が説明できる
    fallback:
    - pip install pandas で導入、巨大データは Polars/DuckDB
    - 自動判断が危険な箇所は候補を一覧化し確認を求める
    - PowerShell の Import-Csv | Sort-Object -Unique で簡易処理
    risk_level: low
    related:
    - csv-tsv
    - data-analysis
    - spreadsheet
    - statistics
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# data-cleaning

欠損・重複・表記ゆれ・型の整形（クレンジング）

## When to Use
Trigger: データクレンジング, 欠損値, 重複, 表記ゆれ, 正規化, 外れ値

## Tools
- required: terminal, execute_code
- optional: read_file, write_file
- dependencies: pandas（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. df.info() / df.describe(include="all") / df.isna().sum() で品質を診断する
2. 型変換（pd.to_datetime/to_numeric(errors="coerce")）と全半角・空白（str.strip, unicodedata.normalize("NFKC")）を統一する
3. 重複は df.duplicated(subset=キー, keep=False) で確認後に除去ルールを決める
4. 欠損・外れ値は削除/補完/フラグ化のどれにするか理由を記録する
5. 整形前後の件数と変更ログ（何行どう変えたか）を出力し、結果は別ファイルへ保存する

## Verification
整形後の期待制約（キー一意・型・範囲）を assert で確認でき、行数の増減が説明できる

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. pip install pandas で導入、巨大データは Polars/DuckDB
2. 自動判断が危険な箇所は候補を一覧化し確認を求める
3. PowerShell の Import-Csv | Sort-Object -Unique で簡易処理

## Related
csv-tsv, data-analysis, spreadsheet, statistics

## Prohibited
- 原データを上書きしない（常に別名出力）
- 理由のない欠損値の削除や値の捏造をしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
