---
name: game-debugging
description: ゲーム固有の不具合調査（再現・ログ・クラッシュ解析）
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
    - ゲームのバグ
    - クラッシュ
    - 挙動がおかしい
    - Unity エラー
    - Unreal クラッシュ
    required_tools:
    - terminal
    - read_file
    - search_files
    optional_tools:
    - vision_analyze
    - patch
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 元の再現手順で再発せず、追加した回帰テストが通る
    fallback:
    - Visual Studio/Rider のデバッガをアタッチして実行状態を確認
    - バージョン管理で git bisect し原因コミットを特定
    - 再現不能なら計装ログを追加して再収集する
    risk_level: low
    related:
    - debugging
    - unity-profiling
    - unreal-cpp
    - testing
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# game-debugging

ゲーム固有の不具合調査（再現・ログ・クラッシュ解析）

## When to Use
Trigger: ゲームのバグ, クラッシュ, 挙動がおかしい, Unity エラー, Unreal クラッシュ

## Tools
- required: terminal, read_file, search_files
- optional: vision_analyze, patch
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Reproduce: 手順・シーン/レベル・シード・入力を固定し毎回再現させる
2. Collect evidence: Unity は %USERPROFILE%\AppData\Local\Unity\Editor\Editor.log、Unreal は Saved\Logs と Saved\Crashes を収集する
3. Hypotheses→Measure: 仮説ごとにログ/Gizmos/ブレークポイント/Profiler で実測し、推測で直さない
4. Root cause を特定し最小修正を入れる
5. Regression test（PlayMode/Automation Test）を追加し元手順で Verify する

## Verification
元の再現手順で再発せず、追加した回帰テストが通る

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. Visual Studio/Rider のデバッガをアタッチして実行状態を確認
2. バージョン管理で git bisect し原因コミットを特定
3. 再現不能なら計装ログを追加して再収集する

## Related
debugging, unity-profiling, unreal-cpp, testing

## Prohibited
- 根拠のない修正や警告抑制だけで終えない
- クラッシュダンプ/ログを承認なしで外部送信しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
