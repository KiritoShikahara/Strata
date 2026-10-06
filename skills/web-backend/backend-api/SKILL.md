---
name: backend-api
description: REST/HTTP バックエンド API の実装とテスト
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
    - API 実装
    - エンドポイント
    - FastAPI
    - Express
    - ASP.NET
    - バックエンド
    required_tools:
    - terminal
    - read_file
    - write_file
    - patch
    optional_tools:
    - search_files
    dependencies:
    - node
    - python
    conflicts: []
    workflow: see '## Procedure'
    verification: テストが通り、Invoke-RestMethod で正常系 2xx・不正入力 4xx が期待通り返る
    fallback:
    - pip install fastapi uvicorn / npm i express で導入
    - DB 未構築なら SQLite か Docker Compose で一時 DB を使う
    - ポート使用中は Get-NetTCPConnection -LocalPort で確認し変更
    risk_level: medium
    related:
    - api-design
    - database-design
    - auth
    - nodejs
    - testing
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# backend-api

REST/HTTP バックエンド API の実装とテスト

## When to Use
Trigger: API 実装, エンドポイント, FastAPI, Express, ASP.NET, バックエンド

## Tools
- required: terminal, read_file, write_file, patch
- optional: search_files
- dependencies: node, python（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. api-design で決めた仕様（OpenAPI）とフレームワーク（FastAPI/Express/ASP.NET）を確認する
2. ルーティング・入力検証（pydantic/zod）・サービス層・永続化層を分離して実装する
3. 統一したエラー形式（HTTP ステータス+code）と構造化ログを実装する
4. Invoke-RestMethod / curl.exe でローカルを叩き正常系・異常系を確認する
5. 自動テスト（pytest + httpx / supertest）を追加する

## Verification
テストが通り、Invoke-RestMethod で正常系 2xx・不正入力 4xx が期待通り返る

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. pip install fastapi uvicorn / npm i express で導入
2. DB 未構築なら SQLite か Docker Compose で一時 DB を使う
3. ポート使用中は Get-NetTCPConnection -LocalPort で確認し変更

## Related
api-design, database-design, auth, nodejs, testing

## Prohibited
- 入力を未検証で SQL/コマンドへ渡さない（インジェクション）
- 本番デプロイ・外部へのメール/通知送信は承認なしで行わない
- Approval 対象（permission-policy 参照）は実行前に確認する。
