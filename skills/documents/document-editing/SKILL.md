---
name: document-editing
description: 既存文書を書式を保ったまま編集
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
    - 文書編集
    - 差し替え
    - 修正
    - 追記
    - 書式維持
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - write_file
    - vision_analyze
    dependencies:
    - python-docx
    - python-pptx
    - openpyxl
    conflicts: []
    workflow: see '## Procedure'
    verification: 差分が意図した箇所のみ、再読込で破損なし（Document(path) が開く）
    fallback:
    - python-docx 不可 → document.xml を直接編集して zip 再パック
    - COM (Find.Execute / Replace) で編集
    - pandoc 経由での再生成
    risk_level: medium
    related:
    - document-comparison
    - checkpoint
    - document-authoring
    - office-native-automation
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# document-editing

既存文書を書式を保ったまま編集

## When to Use
Trigger: 文書編集, 差し替え, 修正, 追記, 書式維持

## Tools
- required: terminal, read_file
- optional: write_file, vision_analyze
- dependencies: python-docx, python-pptx, openpyxl（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 編集前に Copy-Item でバックアップ（*.bak.docx）と checkpoint を作成
2. 対象箇所を document-structure-analysis で特定（段落index/スライド/セル）
3. run 単位で text を置換して書式を維持（paragraph.text 代入は書式が消える）
4. 別名で保存し document-comparison で差分確認
5. office-rendering で見た目の崩れを確認

## Verification
差分が意図した箇所のみ、再読込で破損なし（Document(path) が開く）

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. python-docx 不可 → document.xml を直接編集して zip 再パック
2. COM (Find.Execute / Replace) で編集
3. pandoc 経由での再生成

## Related
document-comparison, checkpoint, document-authoring, office-native-automation

## Prohibited
- バックアップ無しで上書きしない
- 変更範囲外を触らない
- 共有・送信は承認なしにしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
