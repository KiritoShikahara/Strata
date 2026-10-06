---
name: benchmark-suite
description: 標準ベンチと自前ベンチで性能を継続計測する
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
    - ベンチマーク
    - benchmark
    - llama-bench
    - 速度比較
    required_tools:
    - terminal
    optional_tools:
    - write_file
    - execute_code
    dependencies:
    - llama-bench
    - python
    conflicts: []
    workflow: see '## Procedure'
    verification: CSV が生成され、条件メタデータ付きで前回と比較できる
    fallback:
    - llama-bench 不在は llama-cpp skill で導入
    - 他負荷で値が揺れる場合は 3 回測定の中央値
    - lm-eval 不可は自前 evals で代替(model-evaluation)
    risk_level: low
    related:
    - model-evaluation
    - gpu-offload
    - llama-cpp
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# benchmark-suite

標準ベンチと自前ベンチで性能を継続計測する

## When to Use
Trigger: ベンチマーク, benchmark, llama-bench, 速度比較

## Tools
- required: terminal
- optional: write_file, execute_code
- dependencies: llama-bench, python（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. llama-bench -m <gguf> -p 512 -n 128 -ngl 99 -o csv > bench\<model>.csv
2. 品質は lm_eval --model local-chat-completions --tasks <task> で実行
3. 条件(GPU・ドライバ・ctx・量子化・日付)を bench\README.md に記録
4. 前回結果と比較し退行を検出する

## Verification
CSV が生成され、条件メタデータ付きで前回と比較できる

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. llama-bench 不在は llama-cpp skill で導入
2. 他負荷で値が揺れる場合は 3 回測定の中央値
3. lm-eval 不可は自前 evals で代替(model-evaluation)

## Related
model-evaluation, gpu-offload, llama-cpp

## Prohibited
- 計測中に他の重い処理を並行しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
