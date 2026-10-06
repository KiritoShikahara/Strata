---
name: technical-docs-research
description: 技術ドキュメント・API 仕様を調べて使い方を確定する
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - research
    category: research
  kiridev:
    namespace: kiridev
    category: research
    triggers:
    - ドキュメント
    - API 仕様
    - リファレンス
    - docs
    required_tools:
    - web_search
    - web_extract
    optional_tools:
    - terminal
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 示したコード例が対象バージョンで実行成功する
    fallback:
    - 公式 docs が薄い場合はリポジトリの tests/examples を gh search code で探す
    - <cmd> --help / Get-Help <cmdlet> -Full でローカル確認
    - docs サイト不通は web-archiving か GitHub の docs/ を直接読む
    risk_level: low
    related:
    - primary-source-first
    - github-research
    - web-research
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# technical-docs-research

技術ドキュメント・API 仕様を調べて使い方を確定する

## When to Use
Trigger: ドキュメント, API 仕様, リファレンス, docs

## Tools
- required: web_search, web_extract
- optional: terminal
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 対象ライブラリのバージョンを確認する(例: pip show <pkg> / npm ls <pkg>)
2. 公式ドキュメントの該当バージョンのページを検索し web_extract で取得
3. シグネチャ・引数・戻り値・非推奨事項を抜き出す
4. 最小の動作例を作り terminal で実行して仕様を確認する

## Verification
示したコード例が対象バージョンで実行成功する

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 公式 docs が薄い場合はリポジトリの tests/examples を gh search code で探す
2. <cmd> --help / Get-Help <cmdlet> -Full でローカル確認
3. docs サイト不通は web-archiving か GitHub の docs/ を直接読む

## Related
primary-source-first, github-research, web-research

## Prohibited
- バージョン不明のまま古い API を断定しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
