---
name: gameplay-systems
description: 移動・戦闘・インベントリ等のゲームプレイ機構実装
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
    - ゲームプレイ
    - キャラクター移動
    - 戦闘システム
    - インベントリ
    - ステート
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
    verification: 想定入力のテスト（境界・連打・同時入力）が通り、フレームレート変更でも挙動が一定
    fallback:
    - エンジン組込み機能（CharacterController/CharacterMovementComponent）を先に検討
    - 複雑なら最小の縦切りプロトタイプで検証する
    - 問題は game-debugging の手順で切り分ける
    risk_level: low
    related:
    - unity
    - unreal-engine
    - game-ai
    - game-design
    - game-debugging
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# gameplay-systems

移動・戦闘・インベントリ等のゲームプレイ機構実装

## When to Use
Trigger: ゲームプレイ, キャラクター移動, 戦闘システム, インベントリ, ステート

## Tools
- required: read_file, write_file, patch, terminal
- optional: search_files
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 機能を入力→状態→結果の流れで定義し、データ（SO/DataAsset/DataTable）と処理を分離する
2. ステートマシン/コンポーネント設計で責務を分け、イベント駆動で結合を減らす
3. 数値バランスは外部データ（JSON/CSV/DataTable）に出し、コードに埋め込まない
4. フレームレート非依存（Time.deltaTime / DeltaSeconds）で実装する
5. 単体/PlayMode テストと Editor での手動プレイで確認する

## Verification
想定入力のテスト（境界・連打・同時入力）が通り、フレームレート変更でも挙動が一定

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. エンジン組込み機能（CharacterController/CharacterMovementComponent）を先に検討
2. 複雑なら最小の縦切りプロトタイプで検証する
3. 問題は game-debugging の手順で切り分ける

## Related
unity, unreal-engine, game-ai, game-design, game-debugging

## Prohibited
- 数値や挙動を根拠なくハードコードしない
- セーブデータ形式変更時に既存データを無断で破棄しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
