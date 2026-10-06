---
name: data-analysis
description: 探索的データ分析（EDA）と傾向・要因の把握
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
    - データ分析
    - 集計
    - EDA
    - 傾向
    - 相関
    - pandas
    required_tools:
    - terminal
    - execute_code
    optional_tools:
    - read_file
    - write_file
    dependencies:
    - pandas
    - matplotlib
    conflicts: []
    workflow: see '## Procedure'
    verification: 各結論に再実行可能なコード/数値があり、集計合計が元データと一致する
    fallback:
    - pip install pandas matplotlib seaborn jupyter で導入
    - 大規模は DuckDB/Polars、小規模は Excel ピボットで代替
    - 再現性のため uv/venv を作り requirements を固定
    risk_level: low
    related:
    - data-cleaning
    - statistics
    - charting
    - report-generation
    - sqlite
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# data-analysis

探索的データ分析（EDA）と傾向・要因の把握

## When to Use
Trigger: データ分析, 集計, EDA, 傾向, 相関, pandas

## Tools
- required: terminal, execute_code
- optional: read_file, write_file
- dependencies: pandas, matplotlib（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 分析の問い・指標・期間・単位を先に明文化する
2. data-cleaning 済みデータで df.groupby / pivot_table による集計を行う
3. 分布・相関・時系列を確認し、外れ値と季節性を調べる
4. 仮説は statistics の手法で検定し、効果量も併記する
5. 結論・根拠数値・限界（サンプル/バイアス）を report-generation でまとめる

## Verification
各結論に再実行可能なコード/数値があり、集計合計が元データと一致する

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. pip install pandas matplotlib seaborn jupyter で導入
2. 大規模は DuckDB/Polars、小規模は Excel ピボットで代替
3. 再現性のため uv/venv を作り requirements を固定

## Related
data-cleaning, statistics, charting, report-generation, sqlite

## Prohibited
- 結論に合う結果だけを選ばない（p-hacking）
- 個人データを外部サービスへ送信しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
