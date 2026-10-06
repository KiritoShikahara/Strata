---
name: unreal-cpp
description: Unreal C++（UCLASS/UPROPERTY/Actor/Component）実装
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
    - Unreal C++
    - UCLASS
    - UPROPERTY
    - UFUNCTION
    - AActor
    - GameMode
    required_tools:
    - terminal
    - read_file
    - write_file
    - patch
    optional_tools:
    - search_files
    dependencies:
    - Visual Studio 2022
    - UnrealBuildTool
    conflicts: []
    workflow: see '## Procedure'
    verification: Development Editor 構成のビルドが成功し、Editor で新クラスが Blueprint から使える
    fallback:
    - VS の「C++ によるゲーム開発」ワークロードを Installer で追加
    - Intermediate\ 削除後に再生成して再ビルド
    - 挙動確認は Blueprint で暫定実装して切り分ける
    risk_level: medium
    related:
    - unreal-engine
    - unreal-blueprint
    - unreal-build-tool
    - game-debugging
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# unreal-cpp

Unreal C++（UCLASS/UPROPERTY/Actor/Component）実装

## When to Use
Trigger: Unreal C++, UCLASS, UPROPERTY, UFUNCTION, AActor, GameMode

## Tools
- required: terminal, read_file, write_file, patch
- optional: search_files
- dependencies: Visual Studio 2022, UnrealBuildTool（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Source\<Module>\ のクラス構成と <Module>.Build.cs の依存モジュールを確認する
2. UCLASS/USTRUCT に GENERATED_BODY() を付け、UPROPERTY/UFUNCTION で Blueprint 公開を設計する
3. ヘッダ追加・マクロ変更時は Editor を閉じてビルドする（Live Coding は関数本体の変更のみ）
4. UPROPERTY なしの UObject 生ポインタを避け TObjectPtr/TWeakObjectPtr を使う
5. ビルドエラーは最初の error から修正し unreal-build-tool で再ビルドする

## Verification
Development Editor 構成のビルドが成功し、Editor で新クラスが Blueprint から使える

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. VS の「C++ によるゲーム開発」ワークロードを Installer で追加
2. Intermediate\ 削除後に再生成して再ビルド
3. 挙動確認は Blueprint で暫定実装して切り分ける

## Related
unreal-engine, unreal-blueprint, unreal-build-tool, game-debugging

## Prohibited
- Docker/WSL 内で Unreal Editor を動かさない
- エンジン本体ソースの無断改変をしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
