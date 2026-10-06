---
name: quantization
description: GGUF 量子化の選択・変換・品質比較
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
    - 量子化
    - quant
    - IQ3_XXS
    - Q4_K_M
    - imatrix
    required_tools:
    - terminal
    optional_tools:
    - web_search
    dependencies:
    - llama-quantize
    - python
    conflicts: []
    workflow: see '## Procedure'
    verification: 出力 GGUF がロードでき、perplexity が基準比で許容範囲内
    fallback:
    - llama-quantize 不在は llama-cpp skill で導入
    - 品質低下が大きい(IQ3_XXS 等)なら Q4_K_M/Q5_K_M へ
    - ディスク不足は配布済み量子化 GGUF を HuggingFace から取得
    risk_level: low
    related:
    - llama-cpp
    - model-selection
    - model-evaluation
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# quantization

GGUF 量子化の選択・変換・品質比較

## When to Use
Trigger: 量子化, quant, IQ3_XXS, Q4_K_M, imatrix

## Tools
- required: terminal
- optional: web_search
- dependencies: llama-quantize, python（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 既存 GGUF の量子化種別を確認(ファイル名または llama-server 起動ログの file type)
2. 変換: python convert_hf_to_gguf.py <hf_dir> --outfile model-f16.gguf
3. llama-quantize [--imatrix imatrix.dat] model-f16.gguf model-Q4_K_M.gguf Q4_K_M
4. llama-perplexity -m <gguf> -f wiki.test.raw で劣化を比較

## Verification
出力 GGUF がロードでき、perplexity が基準比で許容範囲内

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. llama-quantize 不在は llama-cpp skill で導入
2. 品質低下が大きい(IQ3_XXS 等)なら Q4_K_M/Q5_K_M へ
3. ディスク不足は配布済み量子化 GGUF を HuggingFace から取得

## Related
llama-cpp, model-selection, model-evaluation

## Prohibited
- 元モデルファイルを上書き・削除しない
- 出力は新規パスへ書く
- Approval 対象（permission-policy 参照）は実行前に確認する。
