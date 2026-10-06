---
name: json
description: JSON の整形・検証・変換・クエリ（jq/Python/PowerShell）
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - data
    category: data
  kiridev:
    namespace: kiridev
    category: data
    triggers:
    - JSON
    - jq
    - JSON Schema
    - 整形
    - パース
    - ConvertFrom-Json
    required_tools:
    - terminal
    - execute_code
    optional_tools:
    - read_file
    - write_file
    dependencies:
    - jq
    - jsonschema
    conflicts: []
    workflow: see '## Procedure'
    verification: python -m json.tool が成功し、スキーマ検証エラー 0、件数が期待通り
    fallback:
    - winget install jqlang.jq、または Python/PowerShell のみで処理
    - 壊れた JSON は行番号付きエラーから修復（末尾カンマ・コメント）
    - JSON5/コメント付きは json5 パッケージを使う
    risk_level: low
    related:
    - yaml
    - csv-tsv
    - api-design
    - data-cleaning
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# json

JSON の整形・検証・変換・クエリ（jq/Python/PowerShell）

## When to Use
Trigger: JSON, jq, JSON Schema, 整形, パース, ConvertFrom-Json

## Tools
- required: terminal, execute_code
- optional: read_file, write_file
- dependencies: jq, jsonschema（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 妥当性確認: Get-Content f.json -Raw | ConvertFrom-Json か python -m json.tool f.json
2. 構造を確認し必要部分を抽出: jq ".items[] | {id,name}" f.json または ConvertFrom-Json の Select-Object
3. 変換は ConvertTo-Json -Depth 20（既定の深さ 2 で切れるため必須）で別ファイルへ出力する
4. スキーマ検証は jsonschema -i data.json schema.json
5. JSONL は 1 行ずつ処理しメモリを抑える

## Verification
python -m json.tool が成功し、スキーマ検証エラー 0、件数が期待通り

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. winget install jqlang.jq、または Python/PowerShell のみで処理
2. 壊れた JSON は行番号付きエラーから修復（末尾カンマ・コメント）
3. JSON5/コメント付きは json5 パッケージを使う

## Related
yaml, csv-tsv, api-design, data-cleaning

## Prohibited
- 元ファイルを直接上書きしない
- トークン等の Secret を含む JSON を出力・送信しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
