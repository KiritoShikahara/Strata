---
name: shader-hlsl
description: HLSL シェーダーの作成・最適化・デバッグ
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - game-development
    category: game-development
  kiridev:
    namespace: kiridev
    category: game-development
    triggers:
    - HLSL
    - シェーダー
    - Shader Graph
    - マテリアル
    - GPU
    - ピクセルシェーダー
    required_tools:
    - read_file
    - write_file
    - patch
    optional_tools:
    - terminal
    - vision_analyze
    dependencies:
    - dxc
    - RenderDoc
    conflicts: []
    workflow: see '## Procedure'
    verification: dxc がエラー 0 でコンパイルし、実機/Editor で期待の見た目、GPU 時間が予算内
    fallback:
    - winget install LunarG.VulkanSDK 等で dxc を導入、または Windows SDK 同梱の fxc/dxc を使う
    - RenderDoc 未導入は winget install BaldurKarlsson.RenderDoc
    - 難しければ Shader Graph/Material Editor で暫定実装
    risk_level: low
    related:
    - unity
    - unreal-engine
    - asset-pipeline
    - game-debugging
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# shader-hlsl

HLSL シェーダーの作成・最適化・デバッグ

## When to Use
Trigger: HLSL, シェーダー, Shader Graph, マテリアル, GPU, ピクセルシェーダー

## Tools
- required: read_file, write_file, patch
- optional: terminal, vision_analyze
- dependencies: dxc, RenderDoc（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 対象パイプライン（Unity URP/HDRP、Unreal Material/Global Shader）を確認する
2. HLSL を書き、構文検証は dxc -T ps_6_0 -E main shader.hlsl で行う
3. RenderDoc でフレームキャプチャし入出力テクスチャと定数を確認する
4. ALU/テクスチャフェッチ・分岐を減らし、精度（half/float）を見直す
5. 対象 GPU/品質設定で見た目とコストを確認する

## Verification
dxc がエラー 0 でコンパイルし、実機/Editor で期待の見た目、GPU 時間が予算内

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. winget install LunarG.VulkanSDK 等で dxc を導入、または Windows SDK 同梱の fxc/dxc を使う
2. RenderDoc 未導入は winget install BaldurKarlsson.RenderDoc
3. 難しければ Shader Graph/Material Editor で暫定実装

## Related
unity, unreal-engine, asset-pipeline, game-debugging

## Prohibited
- 未検証の巨大ループ/分岐を本番シェーダーに入れない
- GPU ドライバの更新など重要システム設定を承認なしで変更しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
