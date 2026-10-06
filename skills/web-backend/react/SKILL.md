---
name: react
description: React コンポーネント・フック・状態管理の実装
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
    - React
    - useState
    - useEffect
    - JSX
    - Next.js
    - コンポーネント
    required_tools:
    - terminal
    - read_file
    - write_file
    - patch
    optional_tools:
    - browser_snapshot
    - search_files
    dependencies:
    - node
    - npm
    - react
    conflicts: []
    workflow: see '## Procedure'
    verification: npm run lint と npm test が通り、React 警告（key/依存配列）がコンソールに出ない
    fallback:
    - npm create vite@latest -- --template react-ts で最小再現を作る
    - 再レンダー問題は React DevTools Profiler で実測する
    - ビルド不良は node_modules と lockfile を確認し npm ci
    risk_level: low
    related:
    - frontend
    - html-css
    - nodejs
    - testing
    - debugging
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# react

React コンポーネント・フック・状態管理の実装

## When to Use
Trigger: React, useState, useEffect, JSX, Next.js, コンポーネント

## Tools
- required: terminal, read_file, write_file, patch
- optional: browser_snapshot, search_files
- dependencies: node, npm, react（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. package.json の React バージョンとビルド構成（Vite/Next）を確認する
2. props 設計を先に決め、状態は必要最小限で最も近い共通親に置く
3. useEffect は同期目的に限定し依存配列を正しく書く（eslint-plugin-react-hooks）
4. 非同期データは取得ライブラリ（TanStack Query）か Suspense でエラー/ローディング状態も実装する
5. Testing Library と Vitest/Jest でユーザー操作視点のテストを書く

## Verification
npm run lint と npm test が通り、React 警告（key/依存配列）がコンソールに出ない

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. npm create vite@latest -- --template react-ts で最小再現を作る
2. 再レンダー問題は React DevTools Profiler で実測する
3. ビルド不良は node_modules と lockfile を確認し npm ci

## Related
frontend, html-css, nodejs, testing, debugging

## Prohibited
- state の直接変更や依存配列の lint 警告無視をしない
- 本番公開・npm publish は承認なしで行わない
- Approval 対象（permission-policy 参照）は実行前に確認する。
