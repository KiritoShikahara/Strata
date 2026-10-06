---
name: memory-performance
description: C++ のメモリ・CPU 性能の計測と最適化
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
    - メモリリーク
    - パフォーマンス
    - プロファイル
    - キャッシュ
    - 最適化
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - patch
    - vision_analyze
    dependencies:
    - cl
    - wpr
    - vsdiagnostics
    conflicts: []
    workflow: see '## Procedure'
    verification: 同条件の再計測で数値が改善し、リーク/ASan 報告が 0
    fallback:
    - 'wpr 不在: Windows Performance Toolkit (Windows ADK) を導入'
    - Tracy / Optick を組込む
    - std::chrono とカウンタで手動計測
    - WSL の valgrind/perf で代替
    risk_level: low
    related:
    - cpp
    - msvc
    - concurrency
    - ecs
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# memory-performance

C++ のメモリ・CPU 性能の計測と最適化

## When to Use
Trigger: メモリリーク, パフォーマンス, プロファイル, キャッシュ, 最適化

## Tools
- required: terminal, read_file
- optional: patch, vision_analyze
- dependencies: cl, wpr, vsdiagnostics（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Release + /Zi(PDB) で計測用ビルドを作り、ベースライン(フレーム時間/ms)を記録する
2. リークは _CrtDumpMemoryLeaks / /fsanitize=address / VS Diagnostic Tools で検出する
3. CPU は wpr -start CPU; ... ; wpr -stop trace.etl を WPA か Superluminal/VTune で解析する
4. ホットスポットを AoS→SoA、割当削減(arena/pool)、キャッシュ局所性で改善する
5. 変更ごとに再計測し改善率を記録する

## Verification
同条件の再計測で数値が改善し、リーク/ASan 報告が 0

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. wpr 不在: Windows Performance Toolkit (Windows ADK) を導入
2. Tracy / Optick を組込む
3. std::chrono とカウンタで手動計測
4. WSL の valgrind/perf で代替

## Related
cpp, msvc, concurrency, ecs

## Prohibited
- 計測なしで最適化を適用しない
- Debug ビルドの数値で判断しない
- トレースを外部送信しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
