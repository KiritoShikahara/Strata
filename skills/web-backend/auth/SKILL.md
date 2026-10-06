---
name: auth
description: 認証・認可（JWT/OAuth2/セッション）の安全な実装
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
    - 認証
    - 認可
    - ログイン
    - JWT
    - OAuth
    - パスワード
    - セッション
    required_tools:
    - terminal
    - read_file
    - write_file
    - patch
    optional_tools:
    - search_files
    dependencies:
    - argon2
    - jose
    conflicts: []
    workflow: see '## Procedure'
    verification: 未認証 401・権限不足 403 が返り、トークン改ざん/期限切れのテストが通る
    fallback:
    - pip install argon2-cffi / npm i argon2 jose で導入
    - 自前実装が困難なら実績ある IdP/ライブラリ（Auth.js, Keycloak）を使う
    - OAuth 設定不備は redirect URI とスコープを確認
    risk_level: high
    related:
    - backend-api
    - api-design
    - nginx
    - websocket
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# auth

認証・認可（JWT/OAuth2/セッション）の安全な実装

## When to Use
Trigger: 認証, 認可, ログイン, JWT, OAuth, パスワード, セッション

## Tools
- required: terminal, read_file, write_file, patch
- optional: search_files
- dependencies: argon2, jose（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 方式を選ぶ（Cookie セッション/OAuth2 PKCE/JWT）。ブラウザ向けは HttpOnly+Secure+SameSite Cookie を優先
2. パスワードは argon2id か bcrypt でハッシュ化し平文保存しない
3. JWT は短寿命 access + refresh ローテーション、alg 固定、署名鍵は環境変数/Secret store から読む
4. 認可はサーバー側でリソース毎に検証（ロール/オーナー）し、ログイン試行にレート制限を付ける
5. 不正トークン/期限切れ/権限不足のテストを書く

## Verification
未認証 401・権限不足 403 が返り、トークン改ざん/期限切れのテストが通る

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. pip install argon2-cffi / npm i argon2 jose で導入
2. 自前実装が困難なら実績ある IdP/ライブラリ（Auth.js, Keycloak）を使う
3. OAuth 設定不備は redirect URI とスコープを確認

## Related
backend-api, api-design, nginx, websocket

## Prohibited
- Secret・鍵・トークンをコミット/ログ/外部へ送信しない
- 自作暗号・独自ハッシュを使わない。本番 IdP 設定変更は承認が必要
- Approval 対象（permission-policy 参照）は実行前に確認する。
