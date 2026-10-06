---
name: unreal-engine
description: Unreal Engine プロジェクト全般の構成・運用
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
    - Unreal
    - UE5
    - .uproject
    - Unreal Editor
    - レベル
    - アセット
    required_tools:
    - terminal
    - read_file
    - search_files
    optional_tools:
    - write_file
    - patch
    dependencies:
    - Epic Games Launcher
    - UnrealEditor
    conflicts: []
    workflow: see '## Procedure'
    verification: Editor が起動しプロジェクトが開け、Saved\Logs に致命的 Error が無い
    fallback:
    - Epic Games Launcher を winget install EpicGames.EpicGamesLauncher で導入
    - 破損時は Binaries\ Intermediate\ Saved\ を削除し再生成（確認の上）
    - コマンドライン経由は unreal-build-tool を使う
    risk_level: medium
    related:
    - unreal-cpp
    - unreal-blueprint
    - unreal-build-tool
    - gameplay-systems
    - git
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# unreal-engine

Unreal Engine プロジェクト全般の構成・運用

## When to Use
Trigger: Unreal, UE5, .uproject, Unreal Editor, レベル, アセット

## Tools
- required: terminal, read_file, search_files
- optional: write_file, patch
- dependencies: Epic Games Launcher, UnrealEditor（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. *.uproject の EngineAssociation で UE バージョンを確認する
2. Source\ / Content\ / Config\*.ini / Plugins\ の構成を把握する
3. Generate Visual Studio project files（右クリックまたは UnrealBuildTool）でソリューションを生成する
4. Editor はネイティブで起動し、Output Log と Message Log を確認する
5. Saved\Logs\*.log を Select-String "Error|Warning" で確認する

## Verification
Editor が起動しプロジェクトが開け、Saved\Logs に致命的 Error が無い

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. Epic Games Launcher を winget install EpicGames.EpicGamesLauncher で導入
2. 破損時は Binaries\ Intermediate\ Saved\ を削除し再生成（確認の上）
3. コマンドライン経由は unreal-build-tool を使う

## Related
unreal-cpp, unreal-blueprint, unreal-build-tool, gameplay-systems, git

## Prohibited
- Unreal Editor を Docker 内で動かさない（ネイティブ Windows 限定）
- Content\ の .uasset を無断で削除/バイナリ編集しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
