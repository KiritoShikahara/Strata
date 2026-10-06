---
name: unity-editor
description: Unity Editor 拡張・Inspector/メニュー/ツール作成
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
    - Editor 拡張
    - EditorWindow
    - CustomEditor
    - MenuItem
    - Unity ツール
    required_tools:
    - read_file
    - write_file
    - patch
    optional_tools:
    - terminal
    dependencies:
    - Unity Hub
    conflicts: []
    workflow: see '## Procedure'
    verification: Editor でメニュー/ウィンドウが表示され動作し、プレイヤービルドが通る
    fallback:
    - asmdef の Editor プラットフォーム設定を見直す
    - '#if UNITY_EDITOR で囲んでビルド混入を防ぐ'
    - ドメインリロード不具合は Editor 再起動で切り分ける
    risk_level: medium
    related:
    - unity
    - unity-cli
    - asset-pipeline
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# unity-editor

Unity Editor 拡張・Inspector/メニュー/ツール作成

## When to Use
Trigger: Editor 拡張, EditorWindow, CustomEditor, MenuItem, Unity ツール

## Tools
- required: read_file, write_file, patch
- optional: terminal
- dependencies: Unity Hub（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Assets\Editor\ フォルダに Editor 専用スクリプトを置く（ランタイムと asmdef で分離）
2. [MenuItem("Tools/...")] か EditorWindow、[CustomEditor(typeof(X))] で UI を実装する
3. UI Toolkit か IMGUI を選び、SerializedObject/Undo.RecordObject で Undo 対応にする
4. 変更後はドメインリロードを待ち Console を確認して動作テストする
5. ビルド対象に UnityEditor 参照が混入していないか確認する

## Verification
Editor でメニュー/ウィンドウが表示され動作し、プレイヤービルドが通る

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. asmdef の Editor プラットフォーム設定を見直す
2. #if UNITY_EDITOR で囲んでビルド混入を防ぐ
3. ドメインリロード不具合は Editor 再起動で切り分ける

## Related
unity, unity-cli, asset-pipeline

## Prohibited
- Editor 拡張でプロジェクト全体の資産を確認なしで一括書き換え/削除しない
- Unity Editor を Docker で実行しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
