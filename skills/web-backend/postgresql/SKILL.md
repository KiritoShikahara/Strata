---
name: postgresql
description: PostgreSQL の接続・クエリ・チューニング・バックアップ
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
    - PostgreSQL
    - Postgres
    - psql
    - pg_dump
    - EXPLAIN ANALYZE
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - write_file
    dependencies:
    - psql
    - pg_dump
    conflicts: []
    workflow: see '## Procedure'
    verification: SELECT 1 が成功し、EXPLAIN ANALYZE の実行時間が改善、pg_restore で別 DB に復元できる
    fallback:
    - winget install PostgreSQL.PostgreSQL、または docker run -p 5432:5432 postgres:16
    - pg_hba.conf/ポート 5432 の疎通を Test-NetConnection localhost -Port 5432 で確認
    - GUI は pgAdmin / DBeaver
    risk_level: high
    related:
    - database-design
    - mysql
    - backend-api
    - redis
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# postgresql

PostgreSQL の接続・クエリ・チューニング・バックアップ

## When to Use
Trigger: PostgreSQL, Postgres, psql, pg_dump, EXPLAIN ANALYZE

## Tools
- required: terminal, read_file
- optional: write_file
- dependencies: psql, pg_dump（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. psql --version と Get-Service postgresql* でサービスを確認する
2. 接続: psql -h localhost -U <user> -d <db>（パスワードは PGPASSFILE か対話入力）
3. \dt / \d+ <table> / EXPLAIN (ANALYZE, BUFFERS) で構造と実行計画を確認する
4. pg_stat_statements で重いクエリを特定しインデックス・統計（ANALYZE）を見直す
5. バックアップ: pg_dump -Fc -U <user> -f db.dump <db>、復元は pg_restore を別 DB に対して行う

## Verification
SELECT 1 が成功し、EXPLAIN ANALYZE の実行時間が改善、pg_restore で別 DB に復元できる

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. winget install PostgreSQL.PostgreSQL、または docker run -p 5432:5432 postgres:16
2. pg_hba.conf/ポート 5432 の疎通を Test-NetConnection localhost -Port 5432 で確認
3. GUI は pgAdmin / DBeaver

## Related
database-design, mysql, backend-api, redis

## Prohibited
- 本番での DROP/TRUNCATE/WHERE 無し DELETE は承認なしで行わない
- PGPASSWORD の平文記録・ダンプの外部送信をしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
