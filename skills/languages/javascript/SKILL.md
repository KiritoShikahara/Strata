---
name: javascript
description: JavaScript / Node.js のコード作成・実行・テスト
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
    - JavaScript
    - JS
    - Node
    - npm
    - .js
    required_tools:
    - terminal
    - read_file
    - patch
    optional_tools:
    - execute_code
    dependencies:
    - node
    - npm
    conflicts: []
    workflow: see '## Procedure'
    verification: npm test と eslint が成功
    fallback:
    - 'node 不在: winget install OpenJS.NodeJS.LTS'
    - pnpm/yarn/bun に切替
    - 'npm 失敗: npm cache verify と registry 確認'
    - Docker node イメージ
    risk_level: low
    related:
    - typescript
    - testing
    - debugging
    - supply-chain-review
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# javascript

JavaScript / Node.js のコード作成・実行・テスト

## When to Use
Trigger: JavaScript, JS, Node, npm, .js

## Tools
- required: terminal, read_file, patch
- optional: execute_code
- dependencies: node, npm（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. node -v; npm -v と package.json の engines を確認する
2. npm ci(lock あり) または npm install で依存を導入する
3. ESM/CJS("type" フィールド)を確認し npx eslint . で静的検査する
4. npm test / node --test で検証する
5. 非同期処理は async/await と明示的な例外処理で書く

## Verification
npm test と eslint が成功

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. node 不在: winget install OpenJS.NodeJS.LTS
2. pnpm/yarn/bun に切替
3. npm 失敗: npm cache verify と registry 確認
4. Docker node イメージ

## Related
typescript, testing, debugging, supply-chain-review

## Prohibited
- npm publish を承認なしで行わない
- postinstall を未確認の依存を導入しない
- eval で外部入力を実行しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
