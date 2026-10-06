---
name: speaker-notes-analysis
description: PowerPoint のスピーカーノートを抽出・要約
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
    - スピーカーノート
    - notes
    - 発表者メモ
    - notesSlide
    required_tools:
    - terminal
    - read_file
    optional_tools: []
    dependencies:
    - python-pptx
    conflicts: []
    workflow: see '## Procedure'
    verification: notesSlides ファイル数とノート有りスライド数が一致
    fallback:
    - 'COM: Slide.NotesPage.Shapes.Placeholders(2).TextFrame.TextRange.Text'
    - soffice --convert-to odp 後に content.xml を解析
    - ノート付き PDF 出力 (COM ExportAsFixedFormat PrintOutputType=ppPrintOutputNotesPages) → vision
    risk_level: low
    related:
    - powerpoint-pptx
    - document-summarization
    - office-ooxml-inspection
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# speaker-notes-analysis

PowerPoint のスピーカーノートを抽出・要約

## When to Use
Trigger: スピーカーノート, notes, 発表者メモ, notesSlide

## Tools
- required: terminal, read_file
- optional: -
- dependencies: python-pptx（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. python -I で for i,s in enumerate(prs.slides,1): s.has_notes_slide と notes_text_frame.text を出力
2. python-pptx 不可時は ppt/notesSlides/notesSlideN.xml の a:t を抽出
3. ノートとスライド本文の対応を slideN.xml.rels で確認
4. スライド番号ごとにノートの要点・TODO・参照先を整理

## Verification
notesSlides ファイル数とノート有りスライド数が一致

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. COM: Slide.NotesPage.Shapes.Placeholders(2).TextFrame.TextRange.Text
2. soffice --convert-to odp 後に content.xml を解析
3. ノート付き PDF 出力 (COM ExportAsFixedFormat PrintOutputType=ppPrintOutputNotesPages) → vision

## Related
powerpoint-pptx, document-summarization, office-ooxml-inspection

## Prohibited
- ノートの内容を勝手に書き換えない
- 機密ノートの外部送信禁止
- Approval 対象（permission-policy 参照）は実行前に確認する。
