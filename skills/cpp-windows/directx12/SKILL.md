---
name: directx12
description: Direct3D 12 の初期化・同期・コマンドリスト実装
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
    - DirectX 12
    - D3D12
    - PSO
    - CommandList
    - DXC
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
    - dxc
    conflicts: []
    workflow: see '## Procedure'
    verification: Debug layer / GPU-Based Validation でエラー 0、フレームが正常描画
    fallback:
    - 'dxc 不在: Windows SDK か winget install Microsoft.DirectX.ShaderCompiler 相当 / vcpkg directx-dxc'
    - WARP12 で GPU 差を排除
    - PIX (winget install Microsoft.PIX) で解析
    - D3D11 / DirectX 12 Agility SDK 版を確認
    risk_level: low
    related:
    - directx11
    - graphics-debugging
    - concurrency
    - memory-performance
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# directx12

Direct3D 12 の初期化・同期・コマンドリスト実装

## When to Use
Trigger: DirectX 12, D3D12, PSO, CommandList, DXC

## Tools
- required: terminal, read_file, patch
- optional: search_files, vision_analyze
- dependencies: cl, cmake, dxc（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. D3D12GetDebugInterface で Debug layer を有効化後 D3D12CreateDevice を作る
2. CommandQueue / Allocator / CommandList と Fence + イベントで GPU 同期を実装する
3. RootSignature と PipelineState を作り dxc -T ps_6_0 -E main でシェーダをコンパイルする
4. リソースは ResourceBarrier で状態遷移し DescriptorHeap を管理する
5. フレーム数分の Allocator/リソースをリングで回し Present 後に Fence を待つ

## Verification
Debug layer / GPU-Based Validation でエラー 0、フレームが正常描画

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. dxc 不在: Windows SDK か winget install Microsoft.DirectX.ShaderCompiler 相当 / vcpkg directx-dxc
2. WARP12 で GPU 差を排除
3. PIX (winget install Microsoft.PIX) で解析
4. D3D11 / DirectX 12 Agility SDK 版を確認

## Related
directx11, graphics-debugging, concurrency, memory-performance

## Prohibited
- GPU 同期なしでリソースを解放しない
- Debug layer を Release に残さない
- Approval 対象（permission-policy 参照）は実行前に確認する。
