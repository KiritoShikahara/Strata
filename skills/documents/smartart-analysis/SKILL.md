---
name: smartart-analysis
description: SmartArt(diagrams) の構造とテキストを抽出
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
    - SmartArt
    - diagrams
    - 図表
    - 組織図
    - data1.xml
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - vision_analyze
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 抽出ノード数と画像上のノード数が一致、親子関係が箇条書き/ツリーで再現できる
    fallback:
    - data.xml 解析不能 → drawing*.xml のみ利用
    - 'COM: Shape.SmartArt.AllNodes で取得'
    - レンダリング画像 → vision → 最後に OCR
    risk_level: low
    related:
    - office-ooxml-inspection
    - powerpoint-pptx
    - office-rendering
    - chart-analysis
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# smartart-analysis

SmartArt(diagrams) の構造とテキストを抽出

## When to Use
Trigger: SmartArt, diagrams, 図表, 組織図, data1.xml

## Tools
- required: terminal, read_file
- optional: vision_analyze
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 展開した ppt|word|xl/diagrams/data*.xml を読み dgm:pt の a:t でノードテキストを抽出
2. dgm:cxn の srcId/destId から親子関係（階層・フロー）を復元
3. layout*.xml で図の種別（階層/循環/リスト）を判別
4. drawing*.xml (dsp:) に描画済みキャッシュのテキスト・座標がある場合は併用
5. office-rendering で画像化し vision で見た目と突合

## Verification
抽出ノード数と画像上のノード数が一致、親子関係が箇条書き/ツリーで再現できる

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. data.xml 解析不能 → drawing*.xml のみ利用
2. COM: Shape.SmartArt.AllNodes で取得
3. レンダリング画像 → vision → 最後に OCR

## Related
office-ooxml-inspection, powerpoint-pptx, office-rendering, chart-analysis

## Prohibited
- SmartArt は読めないと言わない
- 元ファイル変更禁止
- Approval 対象（permission-policy 参照）は実行前に確認する。
