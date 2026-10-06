---
name: nginx
description: nginx のリバースプロキシ・静的配信・設定検証
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - web-backend
    category: web-backend
  kiridev:
    namespace: kiridev
    category: web-backend
    triggers:
    - nginx
    - リバースプロキシ
    - SSL
    - 設定
    - upstream
    - 502
    required_tools:
    - terminal
    - read_file
    - write_file
    optional_tools:
    - patch
    dependencies:
    - nginx
    conflicts: []
    workflow: see '## Procedure'
    verification: nginx -t が successful で、curl.exe -I が期待ステータスを返す
    fallback:
    - winget install nginxinc.nginx もしくは Docker（nginx:stable）で実行
    - ポート 80 競合は Get-NetTCPConnection -LocalPort 80 で占有プロセスを確認
    - Caddy / IIS ARR で代替する
    risk_level: high
    related:
    - backend-api
    - websocket
    - auth
    - redis
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# nginx

nginx のリバースプロキシ・静的配信・設定検証

## When to Use
Trigger: nginx, リバースプロキシ, SSL, 設定, upstream, 502

## Tools
- required: terminal, read_file, write_file
- optional: patch
- dependencies: nginx（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 設定ファイル（conf\nginx.conf）を確認し、変更前にコピーでバックアップする
2. server/location/upstream を設定し proxy_set_header Host / X-Forwarded-* を付ける
3. 適用前に nginx -t で構文検証し、nginx -s reload で反映する
4. 502/504 は logs\error.log と upstream の疎通（Test-NetConnection）を確認する
5. 検証: curl.exe -I http://localhost/ でステータスとヘッダを確認する

## Verification
nginx -t が successful で、curl.exe -I が期待ステータスを返す

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. winget install nginxinc.nginx もしくは Docker（nginx:stable）で実行
2. ポート 80 競合は Get-NetTCPConnection -LocalPort 80 で占有プロセスを確認
3. Caddy / IIS ARR で代替する

## Related
backend-api, websocket, auth, redis

## Prohibited
- 本番設定の変更・reload・証明書/秘密鍵の外部送信は承認なしで行わない
- Windows ファイアウォール等の重要システム設定を承認なしで変更しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
