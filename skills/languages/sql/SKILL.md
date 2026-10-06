---
name: sql
description: SQL の作成・最適化・安全な実行
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - languages
    category: languages
  kiridev:
    namespace: kiridev
    category: languages
    triggers:
    - SQL
    - クエリ
    - SELECT
    - SQLite
    - PostgreSQL
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - execute_code
    dependencies:
    - sqlite3
    - psql
    - sqlcmd
    conflicts: []
    workflow: see '## Procedure'
    verification: 対象件数が想定どおりで EXPLAIN に全表走査がない
    fallback:
    - 'sqlite3 不在: winget install SQLite.SQLite または Python sqlite3 モジュール'
    - 'psql 不在: winget install PostgreSQL.PostgreSQL'
    - Docker の DB イメージで検証用 DB を立てる
    - Python (sqlalchemy/pyodbc) で実行
    risk_level: high
    related:
    - python
    - backup-restore
    - security-review
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# sql

SQL の作成・最適化・安全な実行

## When to Use
Trigger: SQL, クエリ, SELECT, SQLite, PostgreSQL

## Tools
- required: terminal, read_file
- optional: execute_code
- dependencies: sqlite3, psql, sqlcmd（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 対象 DB 種別(SQLite/PostgreSQL/SQL Server)と接続先を確認する
2. スキーマは .schema (sqlite3) / \d (psql) / sp_help (sqlcmd) で把握する
3. SELECT から始め EXPLAIN (QUERY PLAN / ANALYZE) で索引使用を確認する
4. 更新系は BEGIN; ... で実行前に SELECT で対象件数を確認し、確認後 COMMIT する
5. 値はパラメータ化し文字列連結しない

## Verification
対象件数が想定どおりで EXPLAIN に全表走査がない

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. sqlite3 不在: winget install SQLite.SQLite または Python sqlite3 モジュール
2. psql 不在: winget install PostgreSQL.PostgreSQL
3. Docker の DB イメージで検証用 DB を立てる
4. Python (sqlalchemy/pyodbc) で実行

## Related
python, backup-restore, security-review

## Prohibited
- 本番 DB に承認なしで UPDATE/DELETE/DDL を実行しない
- WHERE なしの更新/削除をしない
- 接続文字列・パスワードを出力しない
- DROP/TRUNCATE を承認なしで実行しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
