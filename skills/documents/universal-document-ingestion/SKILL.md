---
name: universal-document-ingestion
description: Office/PDF/画像入り文書を Fallback Chain で漏れなく抽出
version: 1.0.0
metadata:
  hermes:
    tags: [kiridev, documents, office, fallback]
    category: documents
  kiridev:
    namespace: kiridev
    category: documents
    triggers: [Word を解析, docx, pptx, xlsx, PDF を全部読んで, 画像入り文書, 図表を抽出]
    required_tools: [terminal, read_file]
    optional_tools: [vision_analyze, execute_code]
    dependencies: [python]
    conflicts: []
    workflow: see '## Procedure'
    verification: 抽出結果の段落数/表数/画像数/グラフ数が OOXML の実数と一致し、画像は vision で内容記述済み
    fallback: [Native parser → OOXML 直接解析 → 埋め込みメディア抽出 → Office ネイティブ描画 → PDF/画像化 → Vision → OCR → 別 converter → 検証]
    risk_level: low
    source: hand-written
---

# universal-document-ingestion

「画像が入っているので読めません」とユーザーに投げ返さない。OCR は第一選択にしない。PDF 単体は bundled `pdf` Skill も併用。

## Fallback Chain
1. **Native parser**: python-docx / openpyxl / python-pptx（無ければ `pip install --user ...`）
2. **OOXML direct inspection**（標準ライブラリのみ、まずこれを実行）:
   `python "$env:LOCALAPPDATA\hermes\skills\documents\universal-document-ingestion\scripts\ooxml_extract.py" <file> <outdir>`
   → `outdir/text.md`（段落・見出し・表を Markdown 表に再構成・脚注/コメント・スライドノート・シート値）、
     `outdir/media/`（埋め込み画像）、`outdir/charts/`（chart XML とデータ系列）、`outdir/smartart/`（diagram テキスト）、
     `outdir/manifest.json`（件数・関係）
3. **Embedded media extraction**: 上記 media/ の各画像を確認（EMF/WMF は PNG 変換: `magick` か Office 描画）。
4. **Native Office rendering**: Word/PowerPoint COM で PDF 化
   `$w=New-Object -ComObject Word.Application; $d=$w.Documents.Open('<abs>'); $d.ExportAsFixedFormat('<abs>.pdf',17); $d.Close(); $w.Quit()`
5. **PDF/Image rendering**: `pdftoppm -r 150 -png` / PyMuPDF でページ画像化。
6. **Vision analysis**: 画像・図・グラフ・スクリーンショットを `vision_analyze` で記述（ローカルが非対応なら model-router の vision route）。
7. **OCR**: tesseract（`-l jpn+eng`）。テキスト層が無い/vision が使えない場合のみ。
8. **Alternate converter**: `soffice --headless --convert-to pdf|docx`、`pandoc -t gfm`。
9. **Verification**: manifest の件数と最終レポートの件数を照合。欠落があれば該当段へ戻る。

## Report
構成（見出しツリー）/ 本文要約 / 表（Markdown）/ 画像ごとの内容 / グラフ（種類・系列・値）/ SmartArt / ノート / 未解決箇所。
