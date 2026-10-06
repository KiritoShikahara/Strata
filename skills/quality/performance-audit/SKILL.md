---
name: performance-audit
description: プロファイルとベンチで性能ボトルネックを特定
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
    - 性能
    - パフォーマンス
    - 遅い
    - プロファイル
    - ボトルネック
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - execute_code
    dependencies:
    - py-spy
    - cProfile
    - hyperfine
    conflicts: []
    workflow: see '## Procedure'
    verification: 同条件の前後計測値が提示され、改善が誤差を超えている
    fallback:
    - hyperfine 無し → winget install sharkdp.hyperfine / Measure-Command を10回
    - py-spy 無し → pip install py-spy / cProfile
    - Windows 全体 → perfmon / Get-Counter
    risk_level: low
    related:
    - debugging
    - memory-leak-analysis
    - testing
    - simplicity-yagni
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# performance-audit

プロファイルとベンチで性能ボトルネックを特定

## When to Use
Trigger: 性能, パフォーマンス, 遅い, プロファイル, ボトルネック

## Tools
- required: terminal, read_file
- optional: execute_code
- dependencies: py-spy, cProfile, hyperfine（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 再現可能な計測条件を固定し基準値を測定: Measure-Command { ... } / hyperfine
2. Python: python -m cProfile -o p.out script.py → pstats で上位関数を確認
3. 実行中プロセスは py-spy dump/record --pid
4. ボトルネック1点に絞り仮説→修正→再計測（1回に1変更）
5. 前後の数値を中央値/複数回で比較

## Verification
同条件の前後計測値が提示され、改善が誤差を超えている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. hyperfine 無し → winget install sharkdp.hyperfine / Measure-Command を10回
2. py-spy 無し → pip install py-spy / cProfile
3. Windows 全体 → perfmon / Get-Counter

## Related
debugging, memory-leak-analysis, testing, simplicity-yagni

## Prohibited
- 計測なしの最適化をしない
- 可読性を大きく損なう微最適化をしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
