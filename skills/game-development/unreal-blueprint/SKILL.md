---
name: unreal-blueprint
description: Unreal Blueprint の設計・整理・C++ との連携
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
    - Blueprint
    - ブループリント
    - BP
    - イベントグラフ
    - UMG
    required_tools:
    - read_file
    - computer_use
    optional_tools:
    - vision_analyze
    - terminal
    dependencies:
    - UnrealEditor
    conflicts: []
    workflow: see '## Procedure'
    verification: BP がコンパイル警告/エラー無しで PIE 動作し、Reference Viewer に壊れた参照が無い
    fallback:
    - GUI 操作が困難なら Python（Editor Scripting）で資産を調べる
    - ノードが多い場合は C++ へ移行（unreal-cpp）
    - 壊れた BP は Source Control の前版へ戻す
    risk_level: medium
    related:
    - unreal-engine
    - unreal-cpp
    - gameplay-systems
    - game-debugging
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# unreal-blueprint

Unreal Blueprint の設計・整理・C++ との連携

## When to Use
Trigger: Blueprint, ブループリント, BP, イベントグラフ, UMG

## Tools
- required: read_file, computer_use
- optional: vision_analyze, terminal
- dependencies: UnrealEditor（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Content Browser で対象 BP を特定し Reference Viewer で依存関係を確認する
2. 親クラスを決め、ロジックは関数/マクロに分割しイベントグラフを小さく保つ
3. 共通処理は BlueprintCallable な C++ 関数や Blueprint Function Library に移す
4. Compile 後に PIE で実行し Print String/ブレークポイントで確認する
5. 不要ノードを整理し Message Log の警告を 0 にする

## Verification
BP がコンパイル警告/エラー無しで PIE 動作し、Reference Viewer に壊れた参照が無い

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. GUI 操作が困難なら Python（Editor Scripting）で資産を調べる
2. ノードが多い場合は C++ へ移行（unreal-cpp）
3. 壊れた BP は Source Control の前版へ戻す

## Related
unreal-engine, unreal-cpp, gameplay-systems, game-debugging

## Prohibited
- BP の一括置換/削除/リダイレクタ修正を承認なしで行わない
- Docker で Editor を動かさない
- Approval 対象（permission-policy 参照）は実行前に確認する。
