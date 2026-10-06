---
name: document-summarization
description: 長文・複数文書を要点・決定事項・TODO に要約
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
    - 要約
    - サマリ
    - 概要
    - 議事録まとめ
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - delegate_task
    - vision_analyze
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 要約中の数値・固有名詞を原文と照合、未読部分が無いことを確認
    fallback:
    - 抽出失敗 → fallback の Office 連鎖（OOXML→レンダリング→vision→OCR）
    - 大規模 → delegate_task で分割要約
    - 読めない箇所は範囲を明示して報告
    risk_level: low
    related:
    - universal-document-ingestion
    - speaker-notes-analysis
    - research
    - document-structure-analysis
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# document-summarization

長文・複数文書を要点・決定事項・TODO に要約

## When to Use
Trigger: 要約, サマリ, 概要, 議事録まとめ

## Tools
- required: terminal, read_file
- optional: delegate_task, vision_analyze
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. universal-document-ingestion で全文（図表・ノート含む）を取得
2. 見出し単位に分割し長文は chunk ごとに要約 → 統合（map-reduce）
3. 結論・根拠・決定事項・TODO・数値を分けて整理
4. 原文の節/ページ番号を併記し出典を示す
5. 図表・画像の内容も要約へ含める

## Verification
要約中の数値・固有名詞を原文と照合、未読部分が無いことを確認

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 抽出失敗 → fallback の Office 連鎖（OOXML→レンダリング→vision→OCR）
2. 大規模 → delegate_task で分割要約
3. 読めない箇所は範囲を明示して報告

## Related
universal-document-ingestion, speaker-notes-analysis, research, document-structure-analysis

## Prohibited
- 原文に無い内容を補完しない
- 機密文書の外部サービス送信禁止
- 未読部分を読んだことにしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
