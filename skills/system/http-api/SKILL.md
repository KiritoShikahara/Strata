---
name: http-api
description: HTTP API の呼び出し・検証
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - system
    category: system
  kiridev:
    namespace: kiridev
    category: system
    triggers:
    - API
    - curl
    - REST
    - Invoke-RestMethod
    - HTTP
    required_tools:
    - terminal
    optional_tools:
    - execute_code
    - web_extract
    dependencies:
    - curl.exe
    conflicts: []
    workflow: see '## Procedure'
    verification: HTTP 2xx と期待 JSON フィールドを確認
    fallback:
    - 'curl.exe 不在: Invoke-WebRequest'
    - 'TLS 失敗: -v で証明書チェーン確認、時刻確認'
    - Python requests / httpx を使う
    - Postman/Bruno 相当の手順提示
    risk_level: medium
    related:
    - network-diagnostics
    - secret-scan
    - research
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# http-api

HTTP API の呼び出し・検証

## When to Use
Trigger: API, curl, REST, Invoke-RestMethod, HTTP

## Tools
- required: terminal
- optional: execute_code, web_extract
- dependencies: curl.exe（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. curl.exe -sS -i -X GET "<url>" -H "Accept: application/json" で疎通とヘッダを確認する
2. PowerShell は Invoke-RestMethod -Uri <url> -Method Post -Body ($o|ConvertTo-Json) -ContentType application/json
3. 認証は環境変数($env:API_TOKEN)から参照し直書きしない
4. ステータスコード・レート制限(Retry-After)・スキーマを確認する
5. 書込系は先に GET/dry-run で対象を確認する

## Verification
HTTP 2xx と期待 JSON フィールドを確認

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. curl.exe 不在: Invoke-WebRequest
2. TLS 失敗: -v で証明書チェーン確認、時刻確認
3. Python requests / httpx を使う
4. Postman/Bruno 相当の手順提示

## Related
network-diagnostics, secret-scan, research

## Prohibited
- トークン/Cookie を出力・ログ・外部へ送らない
- 承認なしで POST/DELETE 等の書込を本番 API に送らない
- -k(証明書検証無効)を常用しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
