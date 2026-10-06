---
name: document-comparison
description: 2つの文書の差分を本文・表・書式レベルで比較
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
    - 文書比較
    - 差分
    - diff
    - 新旧対照
    - 変更点
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - vision_analyze
    dependencies:
    - python-docx
    - pandoc
    conflicts: []
    workflow: see '## Procedure'
    verification: 差分件数が分類合計と一致、サンプル数箇所を原文で再確認
    fallback:
    - pandoc 無し → python-docx で段落を抽出して difflib
    - 'COM: Document.Compare / CompareDocuments'
    - PDF 化して pdftotext 比較
    risk_level: low
    related:
    - document-editing
    - document-structure-analysis
    - git
    - verification
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# document-comparison

2つの文書の差分を本文・表・書式レベルで比較

## When to Use
Trigger: 文書比較, 差分, diff, 新旧対照, 変更点

## Tools
- required: terminal, read_file
- optional: vision_analyze
- dependencies: python-docx, pandoc（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 両文書を pandoc a.docx -t plain --wrap=none で正規化テキスト化
2. git diff --no-index --word-diff a.txt b.txt で語単位差分
3. 表は table-reconstruction で CSV 化して pandas で比較
4. 図・レイアウト差は office-rendering の PNG を vision で比較
5. 追加/削除/変更に分類して報告

## Verification
差分件数が分類合計と一致、サンプル数箇所を原文で再確認

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. pandoc 無し → python-docx で段落を抽出して difflib
2. COM: Document.Compare / CompareDocuments
3. PDF 化して pdftotext 比較

## Related
document-editing, document-structure-analysis, git, verification

## Prohibited
- 元ファイルを変更しない
- 比較結果の外部送信禁止
- Approval 対象（permission-policy 参照）は実行前に確認する。
