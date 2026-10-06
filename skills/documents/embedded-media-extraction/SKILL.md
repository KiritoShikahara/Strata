---
name: embedded-media-extraction
description: Office 内の埋め込み画像・動画・OLE を抽出して解析
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
    - 埋め込み画像
    - media
    - OLE
    - 画像抽出
    - embeddings
    required_tools:
    - terminal
    - vision_analyze
    optional_tools:
    - read_file
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: media の全ファイルを解析対象として列挙し、各ファイルに結果が紐づく
    fallback:
    - Expand-Archive 失敗 → python -I -m zipfile -e / 7z x
    - office-rendering で該当ページを画像化して代用
    - COM で Shapes を Export (Shape.Export / CopyPicture)
    risk_level: low
    related:
    - office-ooxml-inspection
    - ocr-fallback
    - universal-document-ingestion
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# embedded-media-extraction

Office 内の埋め込み画像・動画・OLE を抽出して解析

## When to Use
Trigger: 埋め込み画像, media, OLE, 画像抽出, embeddings

## Tools
- required: terminal, vision_analyze
- optional: read_file
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Expand-Archive で展開し word|ppt|xl/media, embeddings を Get-ChildItem
2. _rels/*.rels の Target と画像の対応（どこで使われているか）を取得
3. emf/wmf は soffice --convert-to png または Inkscape で変換
4. vision_analyze で各画像を解析、画像内文字は必要時のみ ocr-fallback
5. embeddings/*.bin / .xlsx(OLE) は別 skill で再帰的に解析

## Verification
media の全ファイルを解析対象として列挙し、各ファイルに結果が紐づく

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. Expand-Archive 失敗 → python -I -m zipfile -e / 7z x
2. office-rendering で該当ページを画像化して代用
3. COM で Shapes を Export (Shape.Export / CopyPicture)

## Related
office-ooxml-inspection, ocr-fallback, universal-document-ingestion

## Prohibited
- 抽出物は専用ディレクトリに保存
- 抽出した実行ファイル(OLE exe)を実行しない
- 画像の外部送信禁止
- Approval 対象（permission-policy 参照）は実行前に確認する。
