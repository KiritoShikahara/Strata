---
name: directx11
description: Direct3D 11 の初期化・描画・シェーダ実装
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
    - DirectX 11
    - D3D11
    - HLSL
    - SwapChain
    - DXGI
    required_tools:
    - terminal
    - read_file
    - patch
    optional_tools:
    - search_files
    - vision_analyze
    dependencies:
    - cl
    - cmake
    - fxc
    conflicts: []
    workflow: see '## Procedure'
    verification: デバッグレイヤーの警告 0 で期待のフレームが描画される (ID3D11InfoQueue)
    fallback:
    - 'Debug layer 不在: Optional Features の Graphics Tools を追加 (承認後)'
    - WARP (D3D_DRIVER_TYPE_WARP) で GPU 非依存確認
    - RenderDoc/PIX でフレームキャプチャ
    - DirectXTK で補助実装
    risk_level: low
    related:
    - directx12
    - graphics-debugging
    - win32
    - gpu-nvidia
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# directx11

Direct3D 11 の初期化・描画・シェーダ実装

## When to Use
Trigger: DirectX 11, D3D11, HLSL, SwapChain, DXGI

## Tools
- required: terminal, read_file, patch
- optional: search_files, vision_analyze
- dependencies: cl, cmake, fxc（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. D3D11CreateDeviceAndSwapChain に D3D11_CREATE_DEVICE_DEBUG(Debug のみ)を指定し FEATURE_LEVEL を確認する
2. BackBuffer から RenderTargetView と DepthStencilView を作り OMSetRenderTargets / RSSetViewports を設定する
3. HLSL は D3DCompileFromFile または fxc /T vs_5_0 /E main でコンパイルしエラーを ID3DBlob から出力する
4. ComPtr<T> で COM を管理し HRESULT は FAILED() で検査する
5. リサイズ時は ResizeBuffers 前に RTV を解放する

## Verification
デバッグレイヤーの警告 0 で期待のフレームが描画される (ID3D11InfoQueue)

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. Debug layer 不在: Optional Features の Graphics Tools を追加 (承認後)
2. WARP (D3D_DRIVER_TYPE_WARP) で GPU 非依存確認
3. RenderDoc/PIX でフレームキャプチャ
4. DirectXTK で補助実装

## Related
directx12, graphics-debugging, win32, gpu-nvidia

## Prohibited
- Release に Debug layer を残さない
- ドライバ設定を承認なしで変更しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
