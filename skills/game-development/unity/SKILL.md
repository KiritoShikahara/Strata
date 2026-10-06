---
name: unity
description: Unity プロジェクトの構成・C# スクリプト・シーン開発
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
    - Unity
    - C#
    - MonoBehaviour
    - Prefab
    - シーン
    - ScriptableObject
    required_tools:
    - terminal
    - read_file
    - write_file
    - patch
    optional_tools:
    - search_files
    dependencies:
    - Unity Hub
    - dotnet
    conflicts: []
    workflow: see '## Procedure'
    verification: Editor の Console にコンパイルエラーが無く、Test Runner の全テストが通る
    fallback:
    - Unity Hub 未導入なら winget install Unity.UnityHub
    - コンパイルエラーは Library\ と Temp\ 削除後に再インポート（確認の上）
    - GUI が使えなければ unity-cli のバッチモードで実行する
    risk_level: medium
    related:
    - unity-editor
    - unity-cli
    - unity-profiling
    - gameplay-systems
    - git
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# unity

Unity プロジェクトの構成・C# スクリプト・シーン開発

## When to Use
Trigger: Unity, C#, MonoBehaviour, Prefab, シーン, ScriptableObject

## Tools
- required: terminal, read_file, write_file, patch
- optional: search_files
- dependencies: Unity Hub, dotnet（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. ProjectSettings\ProjectVersion.txt で Unity バージョンを確認し、Unity Hub で同一版が入っているか見る
2. Assets\ 配下の構成（Scripts/Prefabs/Scenes）と Packages\manifest.json を把握する
3. MonoBehaviour/ScriptableObject を作成。.meta ファイルを必ず対で扱い、Library\ は触らない
4. Unity Editor はネイティブ Windows で起動し、Console の警告/エラーを確認する
5. Edit/Play Mode テスト（Test Runner）で挙動を確認する

## Verification
Editor の Console にコンパイルエラーが無く、Test Runner の全テストが通る

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. Unity Hub 未導入なら winget install Unity.UnityHub
2. コンパイルエラーは Library\ と Temp\ 削除後に再インポート（確認の上）
3. GUI が使えなければ unity-cli のバッチモードで実行する

## Related
unity-editor, unity-cli, unity-profiling, gameplay-systems, git

## Prohibited
- Unity Editor を Docker 内で動かさない（ネイティブ Windows 限定）
- .meta の手動削除・Assets 大量削除は承認なしで行わない
- Approval 対象（permission-policy 参照）は実行前に確認する。
