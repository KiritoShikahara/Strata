---
name: model-selection
description: 用途・VRAM に合うモデルとサイズを選定する
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
    - モデル選定
    - どのモデル
    - Qwen
    - VRAM
    required_tools:
    - terminal
    - web_search
    optional_tools:
    - web_extract
    dependencies:
    - nvidia-smi
    conflicts: []
    workflow: see '## Procedure'
    verification: 選定モデルが実際にロードでき、必要 ctx で OOM しない
    fallback:
    - nvidia-smi 不在は Get-CimInstance Win32_VideoController で GPU 確認
    - 収まらなければ量子化を下げるか小モデルへ
    - 性能不足はクラウド provider へ model-router で切替
    risk_level: low
    related:
    - quantization
    - gpu-offload
    - model-evaluation
    - model-router
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# model-selection

用途・VRAM に合うモデルとサイズを選定する

## When to Use
Trigger: モデル選定, どのモデル, Qwen, VRAM

## Tools
- required: terminal, web_search
- optional: web_extract
- dependencies: nvidia-smi（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. nvidia-smi --query-gpu=name,memory.total,memory.used --format=csv で VRAM 空きを確認
2. 用途(コード/日本語/ツール呼び出し/視覚)と必要コンテキスト長を整理
3. モデルカード(HuggingFace)でライセンス・ツール対応・GGUF サイズを確認
4. 候補を「重み+KV キャッシュ ≦ VRAM 空き」で絞り、model-evaluation で比較

## Verification
選定モデルが実際にロードでき、必要 ctx で OOM しない

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. nvidia-smi 不在は Get-CimInstance Win32_VideoController で GPU 確認
2. 収まらなければ量子化を下げるか小モデルへ
3. 性能不足はクラウド provider へ model-router で切替

## Related
quantization, gpu-offload, model-evaluation, model-router

## Prohibited
- ライセンス未確認のモデルを配布用途に選ばない
- Approval 対象（permission-policy 参照）は実行前に確認する。
