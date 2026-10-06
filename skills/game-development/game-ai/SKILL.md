---
name: game-ai
description: ゲーム AI（経路探索・ビヘイビアツリー・ステートマシン）
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
    - ゲーム AI
    - NavMesh
    - ビヘイビアツリー
    - A*
    - 敵 AI
    - 経路探索
    required_tools:
    - read_file
    - write_file
    - patch
    - terminal
    optional_tools:
    - search_files
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: AI が想定シナリオで目標に到達し、100 体同時でもフレーム時間が予算内
    fallback:
    - 既存パッケージ（Behavior Designer 等）の導入を検討（ライセンス確認）
    - NavMesh が使えなければグリッド A* を自前実装
    - 挙動不良は game-debugging で状態ログを取る
    risk_level: low
    related:
    - gameplay-systems
    - unity
    - unreal-engine
    - game-debugging
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# game-ai

ゲーム AI（経路探索・ビヘイビアツリー・ステートマシン）

## When to Use
Trigger: ゲーム AI, NavMesh, ビヘイビアツリー, A*, 敵 AI, 経路探索

## Tools
- required: read_file, write_file, patch, terminal
- optional: search_files
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 求める挙動をスキル/状態/条件の表に整理する
2. 単純なら FSM、分岐が多ければ Behavior Tree/Utility AI を選ぶ（Unreal: BT+Blackboard+EQS）
3. NavMesh（Unity NavMeshSurface / Unreal NavMeshBoundsVolume）をベイクして経路を確認する
4. 知覚（視界・聴覚）と意思決定の更新頻度を分け、重い処理は間引く
5. デバッグ描画（Gizmos/Visual Logger）で状態遷移を可視化し調整する

## Verification
AI が想定シナリオで目標に到達し、100 体同時でもフレーム時間が予算内

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 既存パッケージ（Behavior Designer 等）の導入を検討（ライセンス確認）
2. NavMesh が使えなければグリッド A* を自前実装
3. 挙動不良は game-debugging で状態ログを取る

## Related
gameplay-systems, unity, unreal-engine, game-debugging

## Prohibited
- 有償アセットの購入は承認なしで行わない
- フレーム毎の全体探索など未計測の重い処理を入れない
- Approval 対象（permission-policy 参照）は実行前に確認する。
