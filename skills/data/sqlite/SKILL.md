---
name: sqlite
description: SQLite DB の作成・クエリ・インポート/エクスポート
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
    - SQLite
    - sqlite3
    - .db
    - ローカル DB
    - SQL
    required_tools:
    - terminal
    - execute_code
    optional_tools:
    - read_file
    - write_file
    dependencies:
    - sqlite3
    conflicts: []
    workflow: see '## Procedure'
    verification: PRAGMA integrity_check が ok で、件数/集計が元データと一致する
    fallback:
    - winget install SQLite.SQLite、または Python の sqlite3 モジュールを使う
    - ロック時（database is locked）は他プロセス確認と PRAGMA busy_timeout
    - DuckDB で CSV を直接クエリする
    risk_level: medium
    related:
    - csv-tsv
    - database-design
    - data-analysis
    - postgresql
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# sqlite

SQLite DB の作成・クエリ・インポート/エクスポート

## When to Use
Trigger: SQLite, sqlite3, .db, ローカル DB, SQL

## Tools
- required: terminal, execute_code
- optional: read_file, write_file
- dependencies: sqlite3（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. sqlite3 -version か Python 標準 sqlite3 で利用可否を確認し、DB は先に Copy-Item でバックアップする
2. 構造確認: sqlite3 x.db ".tables" ".schema <table>"
3. CSV 取り込み: sqlite3 x.db ".mode csv" ".import --skip 1 f.csv tbl"
4. 更新系は BEGIN; … ; 結果確認 → COMMIT/ROLLBACK で行い、パラメータバインドを使う
5. EXPLAIN QUERY PLAN と CREATE INDEX で遅いクエリを改善し PRAGMA integrity_check で検査する

## Verification
PRAGMA integrity_check が ok で、件数/集計が元データと一致する

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. winget install SQLite.SQLite、または Python の sqlite3 モジュールを使う
2. ロック時（database is locked）は他プロセス確認と PRAGMA busy_timeout
3. DuckDB で CSV を直接クエリする

## Related
csv-tsv, database-design, data-analysis, postgresql

## Prohibited
- バックアップ無しで DROP/DELETE（WHERE 無し）をしない
- DB ファイルを外部へ送信しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
