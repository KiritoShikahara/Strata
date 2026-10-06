---
name: charting
description: グラフ作成（matplotlib/plotly）と可視化の選定
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
    - グラフ
    - チャート
    - 可視化
    - matplotlib
    - plotly
    - 棒グラフ
    - 折れ線
    required_tools:
    - terminal
    - execute_code
    optional_tools:
    - vision_analyze
    - write_file
    dependencies:
    - matplotlib
    - plotly
    conflicts: []
    workflow: see '## Procedure'
    verification: 出力画像が開け、軸・単位・日本語が正しく表示され、数値が元データと一致する
    fallback:
    - pip install matplotlib plotly kaleido で導入
    - Python 不可は Excel/PowerShell の Chart、または Mermaid/ASCII 表
    - 豆腐（文字化け）は japanize-matplotlib かフォントパスを直接指定
    risk_level: low
    related:
    - data-analysis
    - report-generation
    - spreadsheet
    - html-css
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# charting

グラフ作成（matplotlib/plotly）と可視化の選定

## When to Use
Trigger: グラフ, チャート, 可視化, matplotlib, plotly, 棒グラフ, 折れ線

## Tools
- required: terminal, execute_code
- optional: vision_analyze, write_file
- dependencies: matplotlib, plotly（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 伝えたい比較（推移/比較/構成/分布）に合うグラフ種別を選ぶ
2. matplotlib で fig, ax = plt.subplots(figsize=(8,4.5)) を作り軸ラベル・単位・タイトルを付ける
3. 日本語は font（Yu Gothic / Meiryo）を rcParams["font.family"] に設定して文字化けを防ぐ
4. plt.savefig("out.png", dpi=200, bbox_inches="tight")、対話用は plotly の write_html
5. vision_analyze で凡例・重なり・色覚配慮を確認する

## Verification
出力画像が開け、軸・単位・日本語が正しく表示され、数値が元データと一致する

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. pip install matplotlib plotly kaleido で導入
2. Python 不可は Excel/PowerShell の Chart、または Mermaid/ASCII 表
3. 豆腐（文字化け）は japanize-matplotlib かフォントパスを直接指定

## Related
data-analysis, report-generation, spreadsheet, html-css

## Prohibited
- 軸の切り詰め等で誤解を招く表現をしない
- 機密データのグラフを外部へ送信/公開しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
