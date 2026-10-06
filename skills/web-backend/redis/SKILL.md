---
name: redis
description: Redis のキャッシュ・キュー・セッション運用とデバッグ
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
    - Redis
    - キャッシュ
    - redis-cli
    - TTL
    - pub/sub
    - セッション
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - write_file
    dependencies:
    - redis-cli
    - redis-server
    conflicts: []
    workflow: see '## Procedure'
    verification: PING が PONG を返し、TTL が設定されキー数/メモリが想定内である
    fallback:
    - winget install Redis.Redis もしくは Memurai を利用
    - 接続不可は Test-NetConnection localhost -Port 6379 を確認
    - 小規模なら Python dict/SQLite で代替して設計を検証
    risk_level: medium
    related:
    - backend-api
    - postgresql
    - websocket
    - nginx
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# redis

Redis のキャッシュ・キュー・セッション運用とデバッグ

## When to Use
Trigger: Redis, キャッシュ, redis-cli, TTL, pub/sub, セッション

## Tools
- required: terminal, read_file
- optional: write_file
- dependencies: redis-cli, redis-server（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Windows では WSL/Docker 上の Redis を使う: docker run -d -p 6379:6379 redis:7
2. redis-cli -h localhost ping で疎通、INFO memory / INFO stats で状態を確認する
3. キー設計（prefix:entity:id）と TTL（EXPIRE）を決め、SCAN でキーを走査する（KEYS * は使わない）
4. maxmemory-policy（allkeys-lru 等）と永続化（RDB/AOF）を要件に合わせる
5. 遅い処理は SLOWLOG GET と redis-cli --latency で調べる

## Verification
PING が PONG を返し、TTL が設定されキー数/メモリが想定内である

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. winget install Redis.Redis もしくは Memurai を利用
2. 接続不可は Test-NetConnection localhost -Port 6379 を確認
3. 小規模なら Python dict/SQLite で代替して設計を検証

## Related
backend-api, postgresql, websocket, nginx

## Prohibited
- 本番での FLUSHALL/FLUSHDB/KEYS * は承認なしで実行しない
- 認証なしで外部公開（bind 0.0.0.0）しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
