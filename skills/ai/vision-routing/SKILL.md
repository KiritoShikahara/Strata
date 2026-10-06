---
name: vision-routing
description: 画像入力を視覚対応モデルへ振り分ける
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - ai
    category: ai
  kiridev:
    namespace: kiridev
    category: ai
    triggers:
    - 視覚モデル
    - vision provider
    - 画像が読めない
    - auxiliary.vision
    required_tools:
    - read_file
    - patch
    optional_tools:
    - vision_analyze
    - terminal
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: vision_analyze がテスト画像の内容を正しく記述する
    fallback:
    - ローカル VLM は llama-server -m <vlm.gguf> --mmproj <mmproj.gguf> で起動
    - クラウド vision が不可なら別 provider へ
    - いずれも不可なら OCR(Tesseract)で文字情報のみ抽出
    risk_level: medium
    related:
    - multi-model-routing
    - vision
    - image-analysis
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# vision-routing

画像入力を視覚対応モデルへ振り分ける

## When to Use
Trigger: 視覚モデル, vision provider, 画像が読めない, auxiliary.vision

## Tools
- required: read_file, patch
- optional: vision_analyze, terminal
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 現在のローカルモデル(Qwen IQ3_XXS 等)が視覚非対応か確認する(mmproj の有無)
2. %LOCALAPPDATA%\hermes\config.yaml の auxiliary.vision に vision 対応 provider/model を設定
3. vision_analyze に小さなテスト画像を渡し応答を確認する
4. 画像以外は従来のローカルモデルで処理することを確認

## Verification
vision_analyze がテスト画像の内容を正しく記述する

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. ローカル VLM は llama-server -m <vlm.gguf> --mmproj <mmproj.gguf> で起動
2. クラウド vision が不可なら別 provider へ
3. いずれも不可なら OCR(Tesseract)で文字情報のみ抽出

## Related
multi-model-routing, vision, image-analysis

## Prohibited
- 機密画像・個人情報を含む画像を外部 provider へ承認なしで送らない
- API キーを出力しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
