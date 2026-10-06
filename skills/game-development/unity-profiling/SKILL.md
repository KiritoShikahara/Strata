---
name: unity-profiling
description: Unity Profiler/Memory Profiler による性能調査
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - game-development
    category: game-development
  kiridev:
    namespace: kiridev
    category: game-development
    triggers:
    - Unity Profiler
    - フレームレート
    - GC
    - Memory Profiler
    - スパイク
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - vision_analyze
    - computer_use
    dependencies:
    - Unity Hub
    conflicts: []
    workflow: see '## Procedure'
    verification: 修正前後のフレーム時間と GC.Alloc を比較し目標（例 16.6ms）を満たす
    fallback:
    - Editor 計測が不安定ならスタンドアロンの Development Build で計測
    - パッケージ無しなら Package Manager で com.unity.memoryprofiler を追加
    - GUI 操作が困難なら -profiler-log-file オプションでログ取得
    risk_level: low
    related:
    - unity
    - profiling-performance
    - game-debugging
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# unity-profiling

Unity Profiler/Memory Profiler による性能調査

## When to Use
Trigger: Unity Profiler, フレームレート, GC, Memory Profiler, スパイク

## Tools
- required: terminal, read_file
- optional: vision_analyze, computer_use
- dependencies: Unity Hub（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 対象ビルドを Development Build + Autoconnect Profiler で起動、または Editor で Play する
2. Window > Analysis > Profiler で CPU/GPU/Rendering/Memory の重いフレームを特定する
3. GC.Alloc 列と Deep Profile で割り当て元を特定、Frame Debugger で描画コールを確認する
4. Profile Analyzer / Memory Profiler パッケージでスナップショット比較する
5. 修正後に同一シーンで再計測し ms と GC を比較記録する

## Verification
修正前後のフレーム時間と GC.Alloc を比較し目標（例 16.6ms）を満たす

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. Editor 計測が不安定ならスタンドアロンの Development Build で計測
2. パッケージ無しなら Package Manager で com.unity.memoryprofiler を追加
3. GUI 操作が困難なら -profiler-log-file オプションでログ取得

## Related
unity, profiling-performance, game-debugging

## Prohibited
- Editor での計測値だけで最適化を確定しない
- Docker 内の Unity で計測しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
