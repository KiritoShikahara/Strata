---
name: mysql
description: MySQL の接続・クエリ・チューニング・バックアップ
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
    - MySQL
    - MariaDB
    - mysql.exe
    - mysqldump
    - スロークエリ
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - write_file
    dependencies:
    - mysql
    - mysqldump
    conflicts: []
    workflow: see '## Procedure'
    verification: SELECT 1 が成功し、変更後の EXPLAIN で型 ALL のフルスキャンが解消している
    fallback:
    - winget install Oracle.MySQL で導入、または docker run -p 3306:3306 mysql:8
    - 接続不可は Get-NetTCPConnection -LocalPort 3306 と認証プラグインを確認
    - GUI として MySQL Workbench / DBeaver を使う
    risk_level: high
    related:
    - database-design
    - postgresql
    - backend-api
    - sqlite
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# mysql

MySQL の接続・クエリ・チューニング・バックアップ

## When to Use
Trigger: MySQL, MariaDB, mysql.exe, mysqldump, スロークエリ

## Tools
- required: terminal, read_file
- optional: write_file
- dependencies: mysql, mysqldump（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. mysql --version と Get-Service MySQL* でサービス状態を確認する
2. 接続: mysql -h 127.0.0.1 -P 3306 -u <user> -p（パスワードは対話入力）
3. SHOW DATABASES / SHOW CREATE TABLE / EXPLAIN FORMAT=TREE でスキーマと実行計画を確認する
4. スロークエリは SET GLOBAL slow_query_log=ON で採取（テスト環境）し索引を見直す
5. バックアップ: mysqldump --single-transaction -u <user> -p <db> > backup.sql

## Verification
SELECT 1 が成功し、変更後の EXPLAIN で型 ALL のフルスキャンが解消している

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. winget install Oracle.MySQL で導入、または docker run -p 3306:3306 mysql:8
2. 接続不可は Get-NetTCPConnection -LocalPort 3306 と認証プラグインを確認
3. GUI として MySQL Workbench / DBeaver を使う

## Related
database-design, postgresql, backend-api, sqlite

## Prohibited
- 本番での DROP/DELETE（WHERE 無し）/ TRUNCATE は承認なしで行わない
- パスワードをコマンドライン引数（-p<pass>）・ログ・リポジトリに残さない
- Approval 対象（permission-policy 参照）は実行前に確認する。
