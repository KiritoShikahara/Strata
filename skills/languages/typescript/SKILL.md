---
name: typescript
description: TypeScript の型設計・ビルド・型チェック
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
    - TypeScript
    - TS
    - tsc
    - tsconfig
    - .ts
    required_tools:
    - terminal
    - read_file
    - patch
    optional_tools:
    - search_files
    dependencies:
    - node
    - typescript
    conflicts: []
    workflow: see '## Procedure'
    verification: npx tsc --noEmit がエラー 0、テスト成功
    fallback:
    - 'tsc 不在: npm i -D typescript'
    - ts-node/tsx で直接実行
    - '@ts-expect-error は理由コメント付きの最終手段'
    - Deno/Bun の組込み TS を使う
    risk_level: low
    related:
    - javascript
    - testing
    - debugging
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# typescript

TypeScript の型設計・ビルド・型チェック

## When to Use
Trigger: TypeScript, TS, tsc, tsconfig, .ts

## Tools
- required: terminal, read_file, patch
- optional: search_files
- dependencies: node, typescript（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. npx tsc -v と tsconfig.json の strict/target/module を確認する
2. npx tsc --noEmit で型エラーを一覧する
3. any を避け unknown と型ガード、判別共用体で修正する
4. ビルドは tsc -p . または tsx/esbuild/vite を既存設定に合わせる
5. vitest/jest でテストを実行する

## Verification
npx tsc --noEmit がエラー 0、テスト成功

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. tsc 不在: npm i -D typescript
2. ts-node/tsx で直接実行
3. @ts-expect-error は理由コメント付きの最終手段
4. Deno/Bun の組込み TS を使う

## Related
javascript, testing, debugging

## Prohibited
- strict を緩めて型エラーを隠さない
- as any の乱用をしない
- npm publish を承認なしで行わない
- Approval 対象（permission-policy 参照）は実行前に確認する。
