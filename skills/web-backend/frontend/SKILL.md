---
name: frontend
description: フロントエンド実装・UI 確認・ビルド全般
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
    - フロントエンド
    - UI
    - Vite
    - レスポンシブ
    - 画面実装
    required_tools:
    - terminal
    - read_file
    - write_file
    - patch
    optional_tools:
    - browser_navigate
    - browser_snapshot
    - browser_vision
    dependencies:
    - node
    - npm
    conflicts: []
    workflow: see '## Procedure'
    verification: npm run build が終了コード 0 で、ブラウザのコンソールにエラーが無く画面が期待通り
    fallback:
    - winget install OpenJS.NodeJS.LTS で Node を導入
    - ポート競合は --port を変更、node_modules 破損は削除して npm ci
    - ブラウザ操作不可なら Playwright（npx playwright test）で確認
    risk_level: low
    related:
    - html-css
    - react
    - nodejs
    - api-design
    - testing
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# frontend

フロントエンド実装・UI 確認・ビルド全般

## When to Use
Trigger: フロントエンド, UI, Vite, レスポンシブ, 画面実装

## Tools
- required: terminal, read_file, write_file, patch
- optional: browser_navigate, browser_snapshot, browser_vision
- dependencies: node, npm（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. package.json の scripts と使用フレームワーク（vite/next 等）を確認する
2. npm install 後 npm run dev で起動し、browser_navigate で http://localhost:5173 等を開く
3. コンポーネント単位で実装し、状態・アクセシビリティ（aria/label）を満たす
4. browser_snapshot とスクリーンショットでレイアウトを幅 360/768/1280 で確認する
5. npm run lint / npm run build / npm test を通す

## Verification
npm run build が終了コード 0 で、ブラウザのコンソールにエラーが無く画面が期待通り

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. winget install OpenJS.NodeJS.LTS で Node を導入
2. ポート競合は --port を変更、node_modules 破損は削除して npm ci
3. ブラウザ操作不可なら Playwright（npx playwright test）で確認

## Related
html-css, react, nodejs, api-design, testing

## Prohibited
- 本番へのデプロイ・公開は承認なしで行わない
- API キー等の Secret をクライアントコードへ埋め込まない
- Approval 対象（permission-policy 参照）は実行前に確認する。
