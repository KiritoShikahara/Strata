---
name: msbuild
description: MSBuild による .sln/.vcxproj のビルドと診断
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
    - MSBuild
    - .sln
    - .vcxproj
    - Visual Studio ビルド
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - patch
    dependencies:
    - msbuild
    - vswhere
    conflicts: []
    workflow: see '## Procedure'
    verification: msbuild の終了コード 0 で "0 Error(s)"
    fallback:
    - 'msbuild 不在: Developer PowerShell for VS を使うか VS Build Tools を winget 導入'
    - dotnet msbuild
    - cmake --build 経由に統一
    - PlatformToolset 不一致は /p:PlatformToolset=v143 で試す
    risk_level: low
    related:
    - cmake
    - msvc
    - win32
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# msbuild

MSBuild による .sln/.vcxproj のビルドと診断

## When to Use
Trigger: MSBuild, .sln, .vcxproj, Visual Studio ビルド

## Tools
- required: terminal, read_file
- optional: patch
- dependencies: msbuild, vswhere（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. & "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe" -latest -find MSBuild\**\Bin\MSBuild.exe でパスを得る
2. msbuild <sln> /m /p:Configuration=Debug /p:Platform=x64 /v:m /bl でビルドする
3. エラーは /fl /flp:logfile=msbuild.log;errorsonly で抽出する
4. .binlog を MSBuild Structured Log Viewer で解析する
5. /t:Clean;Build で再現確認する

## Verification
msbuild の終了コード 0 で "0 Error(s)"

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. msbuild 不在: Developer PowerShell for VS を使うか VS Build Tools を winget 導入
2. dotnet msbuild
3. cmake --build 経由に統一
4. PlatformToolset 不一致は /p:PlatformToolset=v143 で試す

## Related
cmake, msvc, win32

## Prohibited
- VS のインストール構成を承認なしで変更しない
- .vcxproj を全面再生成して既存設定を失わない
- Approval 対象（permission-policy 参照）は実行前に確認する。
