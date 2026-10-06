---
name: ecs
description: ECS (Entity Component System) の設計と実装
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
    - ECS
    - エンティティ
    - コンポーネント
    - EnTT
    - システム
    required_tools:
    - terminal
    - read_file
    - patch
    optional_tools:
    - search_files
    - web_search
    dependencies:
    - cmake
    - entt
    conflicts: []
    workflow: see '## Procedure'
    verification: 単体テストで生成/破棄/反復が正しく、大量エンティティ計測で期待性能
    fallback:
    - 'EnTT 不在: vcpkg / FetchContent で取得'
    - flecs / Bevy 型設計を参照 (web_search)
    - まず単純な SoA 配列で実装し後で ECS 化
    risk_level: low
    related:
    - memory-performance
    - concurrency
    - physics-integration
    - cpp
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# ecs

ECS (Entity Component System) の設計と実装

## When to Use
Trigger: ECS, エンティティ, コンポーネント, EnTT, システム

## Tools
- required: terminal, read_file, patch
- optional: search_files, web_search
- dependencies: cmake, entt（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Entity は ID(世代付き)、Component は POD、System は純粋な処理に分離する
2. 既存実装なら EnTT を vcpkg install entt で導入し registry.view<A,B>() で反復する
3. 自作はスパースセット/アーキタイプでコンポーネントを連続配置にする
4. 構造変更(create/destroy)は反復中に行わず遅延コマンドバッファで適用する
5. システム順序と依存(読取/書込)を明示し並列化可否を決める

## Verification
単体テストで生成/破棄/反復が正しく、大量エンティティ計測で期待性能

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. EnTT 不在: vcpkg / FetchContent で取得
2. flecs / Bevy 型設計を参照 (web_search)
3. まず単純な SoA 配列で実装し後で ECS 化

## Related
memory-performance, concurrency, physics-integration, cpp

## Prohibited
- 反復中に対象コンテナを変更しない
- ライセンス未確認コードを取り込まない
- Approval 対象（permission-policy 参照）は実行前に確認する。
