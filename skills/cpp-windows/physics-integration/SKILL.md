---
name: physics-integration
description: 物理エンジンのゲーム/アプリへの統合
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
    - 物理演算
    - Box2D
    - Bullet
    - PhysX
    - Jolt
    - 衝突判定
    required_tools:
    - terminal
    - read_file
    - patch
    optional_tools:
    - web_search
    - search_files
    dependencies:
    - cmake
    - vcpkg
    conflicts: []
    workflow: see '## Procedure'
    verification: デバッグ描画で衝突が期待どおり、同一入力で再現性があり、フレーム時間が予算内
    fallback:
    - 'ビルド失敗: vcpkg の triplet (x64-windows) とランタイム(/MD)を合わせる'
    - 別エンジンへ切替
    - 単純な AABB/SAT を自作して検証
    - ライセンス確認 (web_search)
    risk_level: low
    related:
    - ecs
    - concurrency
    - cmake
    - graphics-debugging
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# physics-integration

物理エンジンのゲーム/アプリへの統合

## When to Use
Trigger: 物理演算, Box2D, Bullet, PhysX, Jolt, 衝突判定

## Tools
- required: terminal, read_file, patch
- optional: web_search, search_files
- dependencies: cmake, vcpkg（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 要件(2D/3D、剛体、キャラ、決定性)から Box2D / Jolt / Bullet / PhysX を選び vcpkg で導入する
2. 固定タイムステップ(例 1/60 s)+ アキュムレータで Step し、描画は補間する
3. 物理 Body と ECS/シーンの Transform を同期する(単一の真実の所在を決める)
4. 衝突レイヤー/フィルタとコールバックの実行スレッドを設計する
5. デバッグ描画で形状・接触を可視化し挙動を検証する

## Verification
デバッグ描画で衝突が期待どおり、同一入力で再現性があり、フレーム時間が予算内

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. ビルド失敗: vcpkg の triplet (x64-windows) とランタイム(/MD)を合わせる
2. 別エンジンへ切替
3. 単純な AABB/SAT を自作して検証
4. ライセンス確認 (web_search)

## Related
ecs, concurrency, cmake, graphics-debugging

## Prohibited
- ライセンス未確認のライブラリを組み込まない
- 可変フレーム時間で直接 Step しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
