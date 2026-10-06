---
name: profiling-performance
description: CPU/メモリのボトルネックを計測して特定する
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
    - 遅い
    - パフォーマンス
    - プロファイル
    - メモリリーク
    - CPU 使用率
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - execute_code
    dependencies:
    - py-spy
    - dotnet-trace
    conflicts: []
    workflow: see '## Procedure'
    verification: 修正前後の計測値（平均・p95）を比較し目標値を満たしている
    fallback:
    - pip install py-spy / dotnet tool install -g dotnet-trace
    - 標準の timeit / Measure-Command で粗く計測する
    - 管理者権限が要る場合は承認を得るか WSL 上で perf を使う
    risk_level: low
    related:
    - benchmarking
    - debugging
    - testing
    - verification
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# profiling-performance

CPU/メモリのボトルネックを計測して特定する

## When to Use
Trigger: 遅い, パフォーマンス, プロファイル, メモリリーク, CPU 使用率

## Tools
- required: terminal, read_file
- optional: execute_code
- dependencies: py-spy, dotnet-trace（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 遅い操作と目標値を定義し、同一条件で 3 回以上計測してベースラインを取る
2. Python は python -m cProfile -o out.prof app.py か py-spy record -o p.svg --pid <pid>
3. .NET は dotnet-trace collect / dotnet-counters、Node は node --prof / --inspect を使う
4. Windows 全体は Get-Counter "\Processor(_Total)\% Processor Time" や wpr/WPA で確認する
5. 上位のホットスポットのみ修正し、同条件で再計測して改善率を記録する

## Verification
修正前後の計測値（平均・p95）を比較し目標値を満たしている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. pip install py-spy / dotnet tool install -g dotnet-trace
2. 標準の timeit / Measure-Command で粗く計測する
3. 管理者権限が要る場合は承認を得るか WSL 上で perf を使う

## Related
benchmarking, debugging, testing, verification

## Prohibited
- 計測せずに最適化しない
- 可読性を大きく損なう変更や本番プロセスへの無承認アタッチをしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
