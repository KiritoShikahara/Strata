---
name: database-design
description: スキーマ設計・正規化・インデックス・マイグレーション
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
    - DB 設計
    - スキーマ
    - ER 図
    - 正規化
    - マイグレーション
    - インデックス
    required_tools:
    - read_file
    - write_file
    - terminal
    optional_tools:
    - search_files
    dependencies:
    - mysql
    - psql
    - sqlite3
    conflicts: []
    workflow: see '## Procedure'
    verification: 空 DB へマイグレーションが通り、主要クエリの EXPLAIN がインデックスを使用している
    fallback:
    - DB 未導入は Docker で postgres/mysql を起動、または SQLite で先行検証
    - ツール不足は winget install PostgreSQL.PostgreSQL 等で導入
    - 設計が割れる場合は ADR に代替案を残す
    risk_level: medium
    related:
    - mysql
    - postgresql
    - sqlite
    - backend-api
    - system-design
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# database-design

スキーマ設計・正規化・インデックス・マイグレーション

## When to Use
Trigger: DB 設計, スキーマ, ER 図, 正規化, マイグレーション, インデックス

## Tools
- required: read_file, write_file, terminal
- optional: search_files
- dependencies: mysql, psql, sqlite3（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. エンティティと関係（1:N/N:N）を洗い出し ER 図（Mermaid erDiagram）を書く
2. 第3正規形を基準に、性能上必要な箇所のみ意図して非正規化する
3. 主キー・外部キー・NOT NULL・UNIQUE・CHECK 制約を DDL で定義する
4. 主要クエリに合わせインデックスを設計し EXPLAIN (ANALYZE) で効果を確認する
5. マイグレーションツール（Alembic/Flyway/EF Migrations）で up/down を管理する

## Verification
空 DB へマイグレーションが通り、主要クエリの EXPLAIN がインデックスを使用している

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. DB 未導入は Docker で postgres/mysql を起動、または SQLite で先行検証
2. ツール不足は winget install PostgreSQL.PostgreSQL 等で導入
3. 設計が割れる場合は ADR に代替案を残す

## Related
mysql, postgresql, sqlite, backend-api, system-design

## Prohibited
- 本番 DB への DROP/TRUNCATE/大量 UPDATE は承認なしで実行しない
- 個人情報を含むダンプを外部送信しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
