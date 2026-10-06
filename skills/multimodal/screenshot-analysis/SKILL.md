---
name: screenshot-analysis
description: スクリーンショットから UI 状態・エラーを読み取る
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
    - スクリーンショット
    - スクショ
    - エラー画面
    - 画面を見て
    required_tools:
    - vision_analyze
    optional_tools:
    - computer_use
    - terminal
    - browser_vision
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: エラー文言・画面状態が原文どおり転記され、画像と一致する
    fallback:
    - 文字が小さい場合は切り抜き拡大か OCR(tesseract)併用
    - ブラウザ画面は browser_snapshot のテキスト取得を優先
    - 非視覚モデルは vision-routing で振り分け
    risk_level: low
    related:
    - vision
    - ui-ux-analysis
    - debugging
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# screenshot-analysis

スクリーンショットから UI 状態・エラーを読み取る

## When to Use
Trigger: スクリーンショット, スクショ, エラー画面, 画面を見て

## Tools
- required: vision_analyze
- optional: computer_use, terminal, browser_vision
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 取得: Add-Type System.Windows.Forms でキャプチャ、または Win+Shift+S の保存画像のパスを受け取る
2. vision_analyze でウィンドウ・ダイアログ・エラー文言・ボタンを抽出
3. エラー文は原文のまま書き出し、検索・デバッグ(debugging)に引き継ぐ
4. 画面の現在状態と次の操作候補を整理する

## Verification
エラー文言・画面状態が原文どおり転記され、画像と一致する

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 文字が小さい場合は切り抜き拡大か OCR(tesseract)併用
2. ブラウザ画面は browser_snapshot のテキスト取得を優先
3. 非視覚モデルは vision-routing で振り分け

## Related
vision, ui-ux-analysis, debugging

## Prohibited
- 画面内のパスワード・トークン・個人情報を転記・送信しない
- 許可なく常時スクリーンキャプチャしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
