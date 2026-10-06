---
name: graphics-debugging
description: PIX/RenderDoc による描画不具合の調査
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - cpp-windows
    category: cpp-windows
  kiridev:
    namespace: kiridev
    category: cpp-windows
    triggers:
    - PIX
    - RenderDoc
    - 描画バグ
    - 黒画面
    - GPU クラッシュ
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - vision_analyze
    - browser_vision
    dependencies:
    - pix
    - renderdoc
    - dxdiag
    conflicts: []
    workflow: see '## Procedure'
    verification: 原因(状態/シェーダ/同期)を特定し修正後に再キャプチャで期待結果を確認
    fallback:
    - 'RenderDoc 不在: winget install BaldurKarlsson.RenderDoc'
    - 'PIX 不在: winget install Microsoft.PIX'
    - Nsight Graphics / Visual Studio Graphics Analyzer
    - WARP で再現確認
    risk_level: low
    related:
    - directx11
    - directx12
    - gpu-nvidia
    - debugging
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# graphics-debugging

PIX/RenderDoc による描画不具合の調査

## When to Use
Trigger: PIX, RenderDoc, 描画バグ, 黒画面, GPU クラッシュ

## Tools
- required: terminal, read_file
- optional: vision_analyze, browser_vision
- dependencies: pix, renderdoc, dxdiag（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. dxdiag /t dx.txt と nvidia-smi でドライバ/GPU 状態を記録する
2. Debug layer 出力と HRESULT (DXGI_ERROR_DEVICE_REMOVED は GetDeviceRemovedReason) を確認する
3. PIX (GPU capture) または RenderDoc でフレームを取得し RTV/深度/ビューポート/バインドを検査する
4. シェーダデバッグで入出力値を確認し、最小再現に絞り込む
5. vision_analyze でスクリーンショットを比較し、仮説と修正を 1 つずつ検証する

## Verification
原因(状態/シェーダ/同期)を特定し修正後に再キャプチャで期待結果を確認

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. RenderDoc 不在: winget install BaldurKarlsson.RenderDoc
2. PIX 不在: winget install Microsoft.PIX
3. Nsight Graphics / Visual Studio Graphics Analyzer
4. WARP で再現確認

## Related
directx11, directx12, gpu-nvidia, debugging

## Prohibited
- TDR タイムアウト等のシステムレジストリ設定を承認なしで変更しない
- キャプチャに含まれる個人情報を外部送信しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
