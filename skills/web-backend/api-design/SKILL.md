---
name: api-design
description: REST/OpenAPI の API 仕様設計とバージョニング
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
    - API 設計
    - OpenAPI
    - REST
    - エンドポイント設計
    - スキーマ
    - バージョン
    required_tools:
    - read_file
    - write_file
    optional_tools:
    - terminal
    - search_files
    dependencies:
    - openapi
    conflicts: []
    workflow: see '## Procedure'
    verification: redocly lint がエラー 0 で、全エンドポイントに成功/失敗例が定義されている
    fallback:
    - npm i -g @redocly/cli / @stoplight/prism-cli で導入
    - 不可なら Swagger Editor（docker run swaggerapi/swagger-editor）で確認
    - 既存実装から FastAPI の /openapi.json を生成して差分比較
    risk_level: low
    related:
    - backend-api
    - auth
    - database-design
    - frontend
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# api-design

REST/OpenAPI の API 仕様設計とバージョニング

## When to Use
Trigger: API 設計, OpenAPI, REST, エンドポイント設計, スキーマ, バージョン

## Tools
- required: read_file, write_file
- optional: terminal, search_files
- dependencies: openapi（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. リソースと操作を名詞ベースで列挙（GET /orders/{id} 等）し HTTP メソッドと冪等性を決める
2. openapi.yaml にリクエスト/レスポンス/エラー（problem+json）スキーマを定義する
3. ページネーション（cursor）・フィルタ・ソート・レート制限・認証方式を統一する
4. 互換性ポリシー（/v1 か ヘッダ）と廃止手順を決める
5. npx @redocly/cli lint openapi.yaml で検証し、モック（prism mock）で利用者と確認する

## Verification
redocly lint がエラー 0 で、全エンドポイントに成功/失敗例が定義されている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. npm i -g @redocly/cli / @stoplight/prism-cli で導入
2. 不可なら Swagger Editor（docker run swaggerapi/swagger-editor）で確認
3. 既存実装から FastAPI の /openapi.json を生成して差分比較

## Related
backend-api, auth, database-design, frontend

## Prohibited
- 既存クライアントを壊す破壊的変更をバージョン無しで入れない
- 仕様の外部公開・ドキュメント公開は承認なしで行わない
- Approval 対象（permission-policy 参照）は実行前に確認する。
