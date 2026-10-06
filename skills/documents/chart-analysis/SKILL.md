---
name: chart-analysis
description: Office のグラフ(charts) の系列・値・種類を抽出
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
    - グラフ
    - chart
    - charts/chart1.xml
    - 系列
    - 棒グラフ
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - vision_analyze
    dependencies:
    - openpyxl
    conflicts: []
    workflow: see '## Procedure'
    verification: 系列数・カテゴリ数が XML と報告で一致、数値表が再現できる
    fallback:
    - キャッシュ値なし → 埋め込み xlsx から取得
    - 'COM: Chart.SeriesCollection(i).Values / XValues'
    - office-rendering → vision で目視推定（推定値と明記）→ OCR
    risk_level: low
    related:
    - excel-xlsx
    - powerpoint-pptx
    - office-ooxml-inspection
    - table-reconstruction
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# chart-analysis

Office のグラフ(charts) の系列・値・種類を抽出

## When to Use
Trigger: グラフ, chart, charts/chart1.xml, 系列, 棒グラフ

## Tools
- required: terminal, read_file
- optional: vision_analyze
- dependencies: openpyxl（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 展開した charts/chart*.xml の c:barChart/c:lineChart 等でグラフ種類を判定
2. c:ser の c:tx(系列名)・c:cat(軸)・c:val の c:v をキャッシュ値として抽出
3. c:externalData の rels から元 xlsx (embeddings) を特定し openpyxl で元データ取得
4. タイトル・軸ラベル・単位 (c:title, c:valAx) を取得
5. レンダリング画像を vision で確認し傾向を要約

## Verification
系列数・カテゴリ数が XML と報告で一致、数値表が再現できる

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. キャッシュ値なし → 埋め込み xlsx から取得
2. COM: Chart.SeriesCollection(i).Values / XValues
3. office-rendering → vision で目視推定（推定値と明記）→ OCR

## Related
excel-xlsx, powerpoint-pptx, office-ooxml-inspection, table-reconstruction

## Prohibited
- 目視推定値を正確値として断定しない
- 元ファイル変更禁止
- Approval 対象（permission-policy 参照）は実行前に確認する。
