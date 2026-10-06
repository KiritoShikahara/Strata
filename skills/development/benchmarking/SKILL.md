---
name: benchmarking
description: 再現可能なベンチマークの設計と結果比較
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - development
    category: development
  kiridev:
    namespace: kiridev
    category: development
    triggers:
    - ベンチマーク
    - benchmark
    - hyperfine
    - 比較計測
    required_tools:
    - terminal
    - write_file
    optional_tools:
    - read_file
    dependencies:
    - hyperfine
    conflicts: []
    workflow: see '## Procedure'
    verification: 複数回実行で分散が小さく、条件・環境・結果が再現可能な形で記録されている
    fallback:
    - winget install sharkdp.hyperfine で導入
    - 無ければ PowerShell の Measure-Command を反復実行する
    - 環境ノイズが大きければ WSL/Docker で隔離実行する
    risk_level: low
    related:
    - profiling-performance
    - testing
    - verification
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# benchmarking

再現可能なベンチマークの設計と結果比較

## When to Use
Trigger: ベンチマーク, benchmark, hyperfine, 比較計測

## Tools
- required: terminal, write_file
- optional: read_file
- dependencies: hyperfine（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 比較対象と指標（時間・メモリ・スループット）と入力データを固定する
2. CLI は hyperfine --warmup 3 --runs 10 "cmd A" "cmd B" --export-json b.json
3. コード内は pytest-benchmark / BenchmarkDotNet / criterion 等を使う
4. 電源プラン高パフォーマンス・他アプリ停止など環境を揃え、環境情報も記録する
5. 平均・中央値・分散を表にして docs 等へ保存する

## Verification
複数回実行で分散が小さく、条件・環境・結果が再現可能な形で記録されている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. winget install sharkdp.hyperfine で導入
2. 無ければ PowerShell の Measure-Command を反復実行する
3. 環境ノイズが大きければ WSL/Docker で隔離実行する

## Related
profiling-performance, testing, verification

## Prohibited
- 1 回だけの計測で結論を出さない
- 結果の都合の良い部分だけを報告しない。外部への結果公開は承認が必要
- Approval 対象（permission-policy 参照）は実行前に確認する。
