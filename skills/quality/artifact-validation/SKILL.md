---
name: artifact-validation
description: 生成物（ファイル・ビルド・文書）が正しく使えるか検証
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - quality
    category: quality
  kiridev:
    namespace: kiridev
    category: quality
    triggers:
    - 成果物検証
    - 生成物確認
    - ビルド確認
    - 出力チェック
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - vision_analyze
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 各成果物に 存在・形式・内容 の3点の確認結果がある
    fallback:
    - 検証ツール無し → Python 標準ライブラリで代替検証
    - 実行不可環境 → Docker/WSL/Windows Sandbox で確認
    risk_level: low
    related:
    - verification
    - release-readiness
    - spec-compliance
    - office-rendering
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# artifact-validation

生成物（ファイル・ビルド・文書）が正しく使えるか検証

## When to Use
Trigger: 成果物検証, 生成物確認, ビルド確認, 出力チェック

## Tools
- required: terminal, read_file
- optional: vision_analyze
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 存在・サイズ・更新時刻: Get-Item path | Select Length,LastWriteTime（0バイトでない）
2. 形式検証: JSON は python -m json.tool、YAML は yaml.safe_load、zip は Test-Archive/python -m zipfile -t
3. 実行物は --version / --help と最小入力で起動確認、Get-FileHash でハッシュ記録
4. 文書/画像は再読込またはレンダリングして目視 (vision_analyze)
5. 期待値（要件・サンプル）と内容を突合

## Verification
各成果物に 存在・形式・内容 の3点の確認結果がある

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 検証ツール無し → Python 標準ライブラリで代替検証
2. 実行不可環境 → Docker/WSL/Windows Sandbox で確認

## Related
verification, release-readiness, spec-compliance, office-rendering

## Prohibited
- 未検証の成果物を完成と報告しない
- 検証のため成果物を外部へ送信・公開しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
