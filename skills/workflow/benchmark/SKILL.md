---
name: benchmark
description: 速度/品質ベンチを再現可能に計測し記録（モデル含む）
version: 1.0.0
metadata:
  hermes:
    tags: [kiridev, workflow, benchmark]
    category: workflow
  kiridev:
    namespace: kiridev
    category: workflow
    triggers: [/benchmark, 速度を測って, tok/s, 性能比較, どっちが速い]
    required_tools: [terminal]
    optional_tools: [execute_code, write_file]
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 同条件で 3 回以上計測し中央値とばらつきを記録した
    fallback: [計測ツール無し → Measure-Command / Stopwatch で代替]
    risk_level: low
    source: hand-written
---

# benchmark

## Procedure
1. 何を比べるか・指標（時間, tok/s, メモリ, 正答率）・条件（ハード, ビルド構成, モデル, context 長）を固定して書く。
2. ウォームアップ 1 回 → 本計測 3〜5 回。PowerShell: `Measure-Command { <cmd> }`、コード: hyperfine（あれば）。
3. **LLM（Strata/LM Studio）**: 同じプロンプトで `/v1/chat/completions` を叩き、usage と経過時間から tok/s を算出。
   例: `curl -s http://127.0.0.1:8080/v1/chat/completions -H "Content-Type: application/json" -d '{"model":"strata","messages":[{"role":"user","content":"1から20まで数えて"}],"max_tokens":200}'`
   Strata repo に `bench/` があればそれを優先。
4. 中央値・最小・最大を表で報告し、`kdlog.py event benchmark <name> --detail "<median>"` で記録。
5. 結論は「条件つき」で書く（他条件へ一般化しない）。
