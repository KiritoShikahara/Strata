---
name: websocket
description: WebSocket 双方向通信の実装・接続デバッグ
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
    - WebSocket
    - ws
    - socket.io
    - リアルタイム
    - 接続切れ
    - ping
    required_tools:
    - terminal
    - read_file
    - write_file
    - patch
    optional_tools:
    - browser_navigate
    dependencies:
    - node
    - wscat
    conflicts: []
    workflow: see '## Procedure'
    verification: wscat で送受信でき、切断後に自動再接続して状態が復元される
    fallback:
    - npm i -g wscat か Postman の WebSocket 機能を使う
    - 不可なら SSE や long polling に切替
    - 接続失敗はブラウザの Network タブ（101 ステータス）で確認
    risk_level: medium
    related:
    - backend-api
    - nginx
    - nodejs
    - auth
    - redis
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# websocket

WebSocket 双方向通信の実装・接続デバッグ

## When to Use
Trigger: WebSocket, ws, socket.io, リアルタイム, 接続切れ, ping

## Tools
- required: terminal, read_file, write_file, patch
- optional: browser_navigate
- dependencies: node, wscat（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. メッセージ形式（type/payload の JSON）と認証方法（接続時トークン）を決める
2. サーバー: Node は ws、Python は websockets/FastAPI WebSocket で実装する
3. ping/pong ハートビートと指数バックオフ再接続をクライアントに実装する
4. 検証: npx wscat -c ws://localhost:8080 で送受信を確認する
5. リバースプロキシ越しは Upgrade/Connection ヘッダと proxy_read_timeout を設定する

## Verification
wscat で送受信でき、切断後に自動再接続して状態が復元される

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. npm i -g wscat か Postman の WebSocket 機能を使う
2. 不可なら SSE や long polling に切替
3. 接続失敗はブラウザの Network タブ（101 ステータス）で確認

## Related
backend-api, nginx, nodejs, auth, redis

## Prohibited
- 認証なしの公開エンドポイントや無制限のメッセージサイズを許可しない
- ユーザーへの外部通知送信は承認なしで行わない
- Approval 対象（permission-policy 参照）は実行前に確認する。
