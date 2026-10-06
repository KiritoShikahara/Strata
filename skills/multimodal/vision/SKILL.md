---
name: vision
description: 画像の内容を視覚モデルで認識・説明する
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
    - 画像を見て
    - 画像認識
    - この画像
    - vision
    required_tools:
    - vision_analyze
    optional_tools:
    - read_file
    - terminal
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 回答が画像内の具体的要素(文字・物体・位置)を参照している
    fallback:
    - ローカルモデルが非視覚なら vision-routing で vision provider へ
    - 巨大画像は Pillow で縮小(1568px 以下)して再投入
    - 不可なら OCR(tesseract)で文字のみ抽出
    risk_level: low
    related:
    - image-analysis
    - vision-routing
    - screenshot-analysis
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# vision

画像の内容を視覚モデルで認識・説明する

## When to Use
Trigger: 画像を見て, 画像認識, この画像, vision

## Tools
- required: vision_analyze
- optional: read_file, terminal
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 画像パスの存在とサイズを確認: Get-Item <path> | Select Length
2. vision_analyze に画像と具体的な質問(何を知りたいか)を渡す
3. 結果の不確かな箇所は切り抜き・拡大して再解析する
4. 観察事実と推測を分けて回答する

## Verification
回答が画像内の具体的要素(文字・物体・位置)を参照している

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. ローカルモデルが非視覚なら vision-routing で vision provider へ
2. 巨大画像は Pillow で縮小(1568px 以下)して再投入
3. 不可なら OCR(tesseract)で文字のみ抽出

## Related
image-analysis, vision-routing, screenshot-analysis

## Prohibited
- 機密画像を外部 provider へ承認なしで送らない
- 画像内の人物を特定しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
