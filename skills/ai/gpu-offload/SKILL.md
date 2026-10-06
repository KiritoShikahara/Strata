---
name: gpu-offload
description: GPU オフロード層数・VRAM 配分のチューニング
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
    - ngl
    - オフロード
    - VRAM不足
    - OOM
    - 高速化
    required_tools:
    - terminal
    optional_tools:
    - read_file
    dependencies:
    - nvidia-smi
    - llama-server
    conflicts: []
    workflow: see '## Procedure'
    verification: OOM 無しで起動し、llama-bench の t/s が最良値を記録
    fallback:
    - CUDA 版不可は Vulkan ビルド(llama-cpp)を試す
    - 他アプリの VRAM 占有は終了をユーザーに依頼
    - 収まらなければ小モデル/低 bit 量子化へ(model-selection)
    risk_level: low
    related:
    - llama-cpp
    - quantization
    - model-selection
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# gpu-offload

GPU オフロード層数・VRAM 配分のチューニング

## When to Use
Trigger: ngl, オフロード, VRAM不足, OOM, 高速化

## Tools
- required: terminal
- optional: read_file
- dependencies: nvidia-smi, llama-server（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. nvidia-smi -l 1 で VRAM 使用量を監視しながら起動する
2. -ngl 99 から始め OOM なら 10 ずつ減らす、ログの offloaded N/M layers を確認
3. KV キャッシュ削減: -c を縮小、-ctk q8_0 -ctv q8_0 -fa で量子化
4. llama-bench -ngl <n> で t/s を比較し最速設定を採用

## Verification
OOM 無しで起動し、llama-bench の t/s が最良値を記録

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. CUDA 版不可は Vulkan ビルド(llama-cpp)を試す
2. 他アプリの VRAM 占有は終了をユーザーに依頼
3. 収まらなければ小モデル/低 bit 量子化へ(model-selection)

## Related
llama-cpp, quantization, model-selection

## Prohibited
- GPU ドライバ・電力設定を承認なしで変更しない
- 他プロセスを勝手に終了しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
