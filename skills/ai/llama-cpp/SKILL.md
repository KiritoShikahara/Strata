---
name: llama-cpp
description: llama.cpp(llama-server/llama-cli)の導入と実行
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
    - llama.cpp
    - llama-server
    - GGUF
    - llama-cli
    required_tools:
    - terminal
    optional_tools:
    - read_file
    dependencies:
    - llama-server
    - winget
    conflicts: []
    workflow: see '## Procedure'
    verification: /health が ok を返し、/v1/chat/completions が応答する
    fallback:
    - 不在なら winget install ggml.LlamaCpp、または GitHub Releases の win-cuda/vulkan zip を空ディレクトリへ展開
    - VRAM 不足は -ngl を下げる・-c を縮小・小さい量子化へ
    - ネイティブ不可は Docker(ghcr.io/ggml-org/llama.cpp:server)か WSL でビルド
    risk_level: medium
    related:
    - local-llm
    - quantization
    - gpu-offload
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# llama-cpp

llama.cpp(llama-server/llama-cli)の導入と実行

## When to Use
Trigger: llama.cpp, llama-server, GGUF, llama-cli

## Tools
- required: terminal
- optional: read_file
- dependencies: llama-server, winget（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Get-Command llama-server で存在確認、llama-server --version でビルドと CUDA/Vulkan 対応を確認
2. llama-server -m <model.gguf> -c 8192 -ngl 99 --host 127.0.0.1 --port 8080 で起動
3. Invoke-RestMethod http://127.0.0.1:8080/health で起動確認
4. 性能は llama-bench -m <model.gguf> -ngl 99 で計測

## Verification
/health が ok を返し、/v1/chat/completions が応答する

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 不在なら winget install ggml.LlamaCpp、または GitHub Releases の win-cuda/vulkan zip を空ディレクトリへ展開
2. VRAM 不足は -ngl を下げる・-c を縮小・小さい量子化へ
3. ネイティブ不可は Docker(ghcr.io/ggml-org/llama.cpp:server)か WSL でビルド

## Related
local-llm, quantization, gpu-offload

## Prohibited
- --host 0.0.0.0 での公開を承認なしでしない
- 信頼できない GGUF/バイナリを未検証で実行しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
