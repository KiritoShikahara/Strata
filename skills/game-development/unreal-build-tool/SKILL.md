---
name: unreal-build-tool
description: UnrealBuildTool/UAT による C++ ビルドとパッケージ化
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
    - UnrealBuildTool
    - UBT
    - UAT
    - RunUAT
    - BuildCookRun
    - Build.cs
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - patch
    dependencies:
    - UnrealBuildTool
    - RunUAT.bat
    conflicts: []
    workflow: see '## Procedure'
    verification: Build.bat/RunUAT の終了コード 0 で、Binaries\Win64 またはアーカイブ先に成果物がある
    fallback:
    - Epic Games Launcher で VS ツールチェーン要件を満たす版を導入
    - Intermediate\ を削除して再ビルド（確認の上）
    - Editor 内の Platforms > Package Project で手動パッケージ
    risk_level: medium
    related:
    - unreal-engine
    - unreal-cpp
    - build-systems
    - package-release
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# unreal-build-tool

UnrealBuildTool/UAT による C++ ビルドとパッケージ化

## When to Use
Trigger: UnrealBuildTool, UBT, UAT, RunUAT, BuildCookRun, Build.cs

## Tools
- required: terminal, read_file
- optional: patch
- dependencies: UnrealBuildTool, RunUAT.bat（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. エンジンパスを確認（例 C:\Program Files\Epic Games\UE_5.x\Engine）
2. ビルド: & "<Engine>\Build\BatchFiles\Build.bat" <Target>Editor Win64 Development -Project="<path>.uproject" -WaitMutex
3. パッケージ: RunUAT.bat BuildCookRun -project=... -platform=Win64 -clientconfig=Shipping -build -cook -stage -pak -archive -archivedirectory=Out
4. ログ（%LOCALAPPDATA%\UnrealBuildTool\Log.txt）の最初の error を確認する
5. .Build.cs / .Target.cs の依存を修正して再ビルドする

## Verification
Build.bat/RunUAT の終了コード 0 で、Binaries\Win64 またはアーカイブ先に成果物がある

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. Epic Games Launcher で VS ツールチェーン要件を満たす版を導入
2. Intermediate\ を削除して再ビルド（確認の上）
3. Editor 内の Platforms > Package Project で手動パッケージ

## Related
unreal-engine, unreal-cpp, build-systems, package-release

## Prohibited
- ストア/Steam 等への公開・アップロードは承認なしで行わない
- Docker 内で Editor/UAT cook を実行しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
