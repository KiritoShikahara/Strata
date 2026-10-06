---
name: level-design
description: レベル設計（動線・難易度曲線・ペーシング）
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - creative
    category: creative
  kiridev:
    namespace: kiridev
    category: creative
    triggers:
    - レベルデザイン
    - マップ設計
    - 動線
    - 難易度曲線
    - ブロックアウト
    required_tools:
    - read_file
    - write_file
    optional_tools:
    - terminal
    - vision_analyze
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 初見プレイで想定時間内に完走でき、詰み/迷い箇所の記録が解消済み
    fallback:
    - エディタが使えなければ図と表だけでレイアウト案を作る
    - ProBuilder 未導入は Package Manager で追加
    - 比較用に類似ゲームのレベルを research で分析する
    risk_level: low
    related:
    - game-design
    - gameplay-systems
    - unity
    - unreal-engine
    - creative-direction
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# level-design

レベル設計（動線・難易度曲線・ペーシング）

## When to Use
Trigger: レベルデザイン, マップ設計, 動線, 難易度曲線, ブロックアウト

## Tools
- required: read_file, write_file
- optional: terminal, vision_analyze
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 目的（学習/挑戦/報酬）とプレイヤー能力・所要時間を定義する
2. 紙/Mermaid でトップダウン動線と戦闘・休憩・ランドマークの配置を描く
3. グレーボックス（ProBuilder / Unreal BSP）でブロックアウトし寸法を実プレイで調整する
4. 難易度曲線を表（区間・敵数・資源）にして CSV 管理する
5. プレイテストで迷い・詰み箇所を記録し修正する

## Verification
初見プレイで想定時間内に完走でき、詰み/迷い箇所の記録が解消済み

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. エディタが使えなければ図と表だけでレイアウト案を作る
2. ProBuilder 未導入は Package Manager で追加
3. 比較用に類似ゲームのレベルを research で分析する

## Related
game-design, gameplay-systems, unity, unreal-engine, creative-direction

## Prohibited
- 既存作品のマップをそのまま複製しない
- 未確認のまま大規模なシーン/アセットを削除しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
