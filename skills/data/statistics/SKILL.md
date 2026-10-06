---
name: statistics
description: 統計検定・信頼区間・回帰の適切な適用と解釈
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
    - 統計
    - t 検定
    - 信頼区間
    - 回帰
    - p 値
    - 分散分析
    - 相関
    required_tools:
    - terminal
    - execute_code
    optional_tools:
    - read_file
    dependencies:
    - scipy
    - statsmodels
    conflicts: []
    workflow: see '## Procedure'
    verification: 前提の確認結果と検定の統計量・p 値・効果量・信頼区間が再実行で一致する
    fallback:
    - pip install scipy statsmodels pingouin で導入
    - 前提を満たさなければノンパラメトリック/ブートストラップへ切替
    - R があれば Rscript で交差確認する
    risk_level: low
    related:
    - data-analysis
    - data-cleaning
    - charting
    - report-generation
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# statistics

統計検定・信頼区間・回帰の適切な適用と解釈

## When to Use
Trigger: 統計, t 検定, 信頼区間, 回帰, p 値, 分散分析, 相関

## Tools
- required: terminal, execute_code
- optional: read_file
- dependencies: scipy, statsmodels（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. データの種類（連続/カテゴリ・対応有無）と問いから手法を選ぶ
2. 前提（正規性 scipy.stats.shapiro・等分散 levene・独立性）を確認する
3. 検定: scipy.stats.ttest_ind / mannwhitneyu / chi2_contingency、回帰は statsmodels.api.OLS
4. p 値だけでなく効果量と 95% 信頼区間を算出し、多重比較は補正（Bonferroni/BH）する
5. 仮定・手法・結果・解釈をまとめ乱数シードも記録する

## Verification
前提の確認結果と検定の統計量・p 値・効果量・信頼区間が再実行で一致する

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. pip install scipy statsmodels pingouin で導入
2. 前提を満たさなければノンパラメトリック/ブートストラップへ切替
3. R があれば Rscript で交差確認する

## Related
data-analysis, data-cleaning, charting, report-generation

## Prohibited
- 結果に合わせた検定の選び直しや p 値の恣意的な丸めをしない
- 標本が小さいのに強い因果主張をしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
