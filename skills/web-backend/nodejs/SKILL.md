---
name: nodejs
description: Node.js アプリ・スクリプトの開発と実行
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
    - Node.js
    - npm
    - Express
    - package.json
    - TypeScript
    - node
    required_tools:
    - terminal
    - read_file
    - write_file
    - patch
    optional_tools:
    - search_files
    dependencies:
    - node
    - npm
    conflicts: []
    workflow: see '## Procedure'
    verification: npm test が通り node src\index.js が起動してエラー無く応答する
    fallback:
    - winget install OpenJS.NodeJS.LTS、バージョン切替は nvm-windows / fnm
    - パス長/権限問題は短いパスへ移動、または WSL で実行
    - npm が不調なら pnpm / yarn を使う
    risk_level: low
    related:
    - backend-api
    - react
    - dependency-management
    - testing
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# nodejs

Node.js アプリ・スクリプトの開発と実行

## When to Use
Trigger: Node.js, npm, Express, package.json, TypeScript, node

## Tools
- required: terminal, read_file, write_file, patch
- optional: search_files
- dependencies: node, npm（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. node -v / npm -v と package.json の engines・type（module/commonjs）を確認する
2. npm ci（lockfile あり）または npm install で依存を導入する
3. エントリを実装し node --watch src\index.js で実行、環境変数は .env から dotenv/--env-file で読む
4. 非同期はエラー処理（try/catch・unhandledRejection）を付ける
5. node --test か Vitest/Jest でテストし npm audit を確認する

## Verification
npm test が通り node src\index.js が起動してエラー無く応答する

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. winget install OpenJS.NodeJS.LTS、バージョン切替は nvm-windows / fnm
2. パス長/権限問題は短いパスへ移動、または WSL で実行
3. npm が不調なら pnpm / yarn を使う

## Related
backend-api, react, dependency-management, testing

## Prohibited
- .env や認証情報をコミット/ログ出力しない
- npm publish・本番サーバーへのデプロイは承認なしで行わない
- Approval 対象（permission-policy 参照）は実行前に確認する。
