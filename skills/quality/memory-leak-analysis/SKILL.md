---
name: memory-leak-analysis
description: メモリリーク・肥大化の調査と原因特定
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - quality
    category: quality
  kiridev:
    namespace: kiridev
    category: quality
    triggers:
    - メモリリーク
    - メモリ増加
    - OOM
    - tracemalloc
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - process
    dependencies:
    - tracemalloc
    - memray
    - objgraph
    conflicts: []
    workflow: see '## Procedure'
    verification: 同一負荷の反復でメモリが安定（右肩上がりでない）ことをグラフ/数値で確認
    fallback:
    - memray 無し → pip install memray (WSL 推奨) / tracemalloc
    - 'Node: node --inspect と heap snapshot / --heapsnapshot-signal'
    - '.NET: dotnet-counters / dotnet-dump'
    risk_level: low
    related:
    - performance-audit
    - debugging
    - long-running-task
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# memory-leak-analysis

メモリリーク・肥大化の調査と原因特定

## When to Use
Trigger: メモリリーク, メモリ増加, OOM, tracemalloc

## Tools
- required: terminal, read_file
- optional: process
- dependencies: tracemalloc, memray, objgraph（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Get-Process -Name x | Select WS,PM,Handles を一定間隔で記録し増加傾向を確認
2. Python: tracemalloc.start(); snapshot 2点を compare_to(..., "lineno")
3. objgraph.show_growth() で増加オブジェクト型を確認
4. キャッシュ・グローバル・クロージャ・未解除リスナ・未closeリソースを rg で探索
5. 修正後に同負荷で再計測し横ばいを確認

## Verification
同一負荷の反復でメモリが安定（右肩上がりでない）ことをグラフ/数値で確認

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. memray 無し → pip install memray (WSL 推奨) / tracemalloc
2. Node: node --inspect と heap snapshot / --heapsnapshot-signal
3. .NET: dotnet-counters / dotnet-dump

## Related
performance-audit, debugging, long-running-task

## Prohibited
- 本番プロセスを無断で kill/ダンプしない
- ヒープダンプ(機密含む)を外部送信しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
