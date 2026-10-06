---
name: csharp
description: C# / .NET のコード作成・ビルド・テスト
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - languages
    category: languages
  kiridev:
    namespace: kiridev
    category: languages
    triggers:
    - C#
    - csharp
    - .NET
    - dotnet
    - csproj
    required_tools:
    - terminal
    - read_file
    - patch
    optional_tools:
    - search_files
    dependencies:
    - dotnet
    conflicts: []
    workflow: see '## Procedure'
    verification: dotnet build と dotnet test が成功
    fallback:
    - 'SDK 不在: winget install Microsoft.DotNet.SDK.8'
    - 'NuGet 失敗: dotnet nuget locals all --list と source 確認'
    - Docker mcr.microsoft.com/dotnet/sdk
    - csi / dotnet-script で簡易検証
    risk_level: low
    related:
    - testing
    - debugging
    - package-management
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# csharp

C# / .NET のコード作成・ビルド・テスト

## When to Use
Trigger: C#, csharp, .NET, dotnet, csproj

## Tools
- required: terminal, read_file, patch
- optional: search_files
- dependencies: dotnet（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. dotnet --info で SDK 版を確認し global.json/TargetFramework を確認する
2. dotnet restore && dotnet build -warnaserror で構築する
3. #nullable enable、async/await、using/IDisposable を適切に使い修正する
4. dotnet test --no-build で xUnit/NUnit を実行する
5. dotnet format --verify-no-changes でスタイルを確認する

## Verification
dotnet build と dotnet test が成功

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. SDK 不在: winget install Microsoft.DotNet.SDK.8
2. NuGet 失敗: dotnet nuget locals all --list と source 確認
3. Docker mcr.microsoft.com/dotnet/sdk
4. csi / dotnet-script で簡易検証

## Related
testing, debugging, package-management

## Prohibited
- 未検証 NuGet パッケージを追加しない
- nuget への publish を承認なしで行わない
- Approval 対象（permission-policy 参照）は実行前に確認する。
