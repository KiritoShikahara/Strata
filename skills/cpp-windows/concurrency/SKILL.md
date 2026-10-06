---
name: concurrency
description: C++ の並行処理・スレッド安全性の設計と検証
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
    - スレッド
    - mutex
    - atomic
    - データ競合
    - ジョブシステム
    required_tools:
    - terminal
    - read_file
    - patch
    optional_tools:
    - search_files
    dependencies:
    - cl
    - clang
    conflicts: []
    workflow: see '## Procedure'
    verification: TSan/検証ツールで競合 0、ストレスを 1000 回通過
    fallback:
    - TSan は Windows 非対応のため WSL/Docker の clang を使用
    - MSVC /analyze と CppCoreCheck (/analyze:plugin) を使う
    - 設計を単一スレッド+メッセージパッシングに簡略化
    - ロックフリーを避け mutex 版に戻す
    risk_level: low
    related:
    - cpp
    - memory-performance
    - ecs
    - debugging
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# concurrency

C++ の並行処理・スレッド安全性の設計と検証

## When to Use
Trigger: スレッド, mutex, atomic, データ競合, ジョブシステム

## Tools
- required: terminal, read_file, patch
- optional: search_files
- dependencies: cl, clang（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 共有可変状態を洗い出し所有スレッドを明確にする
2. std::mutex + std::scoped_lock / std::atomic(memory_order 既定 seq_cst) / std::jthread で実装する
3. ジョブ/タスクキュー設計では false sharing(alignas(64))とロック順序を確認する
4. clang -fsanitize=thread (WSL/Linux) や Application Verifier、VS Concurrency Visualizer で検証する
5. ストレステスト(多回数ループ・スレッド数変更)で再現性を確認する

## Verification
TSan/検証ツールで競合 0、ストレスを 1000 回通過

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. TSan は Windows 非対応のため WSL/Docker の clang を使用
2. MSVC /analyze と CppCoreCheck (/analyze:plugin) を使う
3. 設計を単一スレッド+メッセージパッシングに簡略化
4. ロックフリーを避け mutex 版に戻す

## Related
cpp, memory-performance, ecs, debugging

## Prohibited
- volatile を同期手段として使わない
- detach したスレッドで寿命管理を放棄しない
- 検証なしでロックフリー化しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
