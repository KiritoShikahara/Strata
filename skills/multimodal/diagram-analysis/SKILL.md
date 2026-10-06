---
name: diagram-analysis
description: 図・フローチャート・ER 図を読み取り構造化する
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - multimodal
    category: multimodal
  kiridev:
    namespace: kiridev
    category: multimodal
    triggers:
    - 図の解析
    - フローチャート
    - 構成図
    - ER図
    - 図を読んで
    required_tools:
    - vision_analyze
    optional_tools:
    - write_file
    - terminal
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 再描画した図のノード数・接続が元図と一致する
    fallback:
    - mmdc 不在は npm i -g @mermaid-js/mermaid-cli、または Mermaid Live の構文確認のみ
    - 読取不能なラベルは「判読不能」と明記
    - 文字が小さい場合は拡大して OCR(tesseract)併用
    risk_level: low
    related:
    - image-analysis
    - vision
    - screenshot-analysis
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# diagram-analysis

図・フローチャート・ER 図を読み取り構造化する

## When to Use
Trigger: 図の解析, フローチャート, 構成図, ER図, 図を読んで

## Tools
- required: vision_analyze
- optional: write_file, terminal
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. vision_analyze で図の種類・ノード・矢印・ラベルを列挙させる
2. 細部は領域を切り抜いて再解析し、ノード間の接続を確認する
3. Mermaid(flowchart/erDiagram)に書き起こし mmdc -i in.mmd -o out.png で再描画
4. 元図と再描画を vision_analyze で比較し差異を修正する

## Verification
再描画した図のノード数・接続が元図と一致する

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. mmdc 不在は npm i -g @mermaid-js/mermaid-cli、または Mermaid Live の構文確認のみ
2. 読取不能なラベルは「判読不能」と明記
3. 文字が小さい場合は拡大して OCR(tesseract)併用

## Related
image-analysis, vision, screenshot-analysis

## Prohibited
- 判読できない要素を推測で補完しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
