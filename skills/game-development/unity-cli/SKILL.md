---
name: unity-cli
description: Unity のバッチモード実行・CLI ビルド・テスト
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
    - Unity batchmode
    - -executeMethod
    - Unity ビルド
    - CLI ビルド
    - CI
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - write_file
    dependencies:
    - Unity.exe
    conflicts: []
    workflow: see '## Procedure'
    verification: $LASTEXITCODE が 0 で results.xml に失敗が無く、成果物が出力先に存在する
    fallback:
    - 同一プロジェクトが開かれて失敗する場合は Editor を閉じる/別コピーで実行
    - ライセンス未取得は Unity Hub でサインインを促す（ユーザー操作）
    - CLI が不可なら Editor の Build Settings から手動ビルド
    risk_level: medium
    related:
    - unity
    - unity-editor
    - build-systems
    - testing
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# unity-cli

Unity のバッチモード実行・CLI ビルド・テスト

## When to Use
Trigger: Unity batchmode, -executeMethod, Unity ビルド, CLI ビルド, CI

## Tools
- required: terminal, read_file
- optional: write_file
- dependencies: Unity.exe（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Editor パスを特定: Get-ChildItem "C:\Program Files\Unity\Hub\Editor" で版を確認する
2. エディタを閉じてから: & "<Unity.exe>" -batchmode -nographics -quit -projectPath . -logFile build.log -executeMethod Build.Run
3. テストは -runTests -testPlatform EditMode -testResults results.xml を使う
4. 終了コードと build.log の "error CS" を Select-String で確認する
5. ライセンスエラー時は Unity Hub 側でライセンスを有効化する

## Verification
$LASTEXITCODE が 0 で results.xml に失敗が無く、成果物が出力先に存在する

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 同一プロジェクトが開かれて失敗する場合は Editor を閉じる/別コピーで実行
2. ライセンス未取得は Unity Hub でサインインを促す（ユーザー操作）
3. CLI が不可なら Editor の Build Settings から手動ビルド

## Related
unity, unity-editor, build-systems, testing

## Prohibited
- Docker で Unity Editor を実行しない（ネイティブ限定）
- ライセンスキー/認証情報をログや外部に出力しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
