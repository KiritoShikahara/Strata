---
name: html-css
description: セマンティック HTML と CSS（Flex/Grid）の実装・修正
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
    - HTML
    - CSS
    - Flexbox
    - Grid
    - レイアウト崩れ
    - スタイル
    required_tools:
    - read_file
    - write_file
    - patch
    optional_tools:
    - browser_navigate
    - browser_snapshot
    - browser_vision
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 幅 360/768/1280px で崩れず、W3C バリデータ/ Lighthouse のアクセシビリティ指摘が無い
    fallback:
    - npx html-validate / npx stylelint で静的検査する
    - ブラウザ操作不可なら Playwright でスクリーンショットを取得
    - CSS 競合は詳細度を確認し !important に頼らず構造で解決
    risk_level: low
    related:
    - frontend
    - react
    - charting
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# html-css

セマンティック HTML と CSS（Flex/Grid）の実装・修正

## When to Use
Trigger: HTML, CSS, Flexbox, Grid, レイアウト崩れ, スタイル

## Tools
- required: read_file, write_file, patch
- optional: browser_navigate, browser_snapshot, browser_vision
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 既存の HTML 構造と CSS の適用範囲（クラス/変数/リセット）を確認する
2. header/nav/main/section/button など意味に合う要素を使い、見出し階層を守る
3. レイアウトは Flexbox/Grid、色・余白は CSS 変数、幅は @media / clamp() で調整する
4. ブラウザの DevTools 相当（browser_snapshot）で適用スタイルとオーバーフローを確認する
5. コントラスト比（4.5:1 以上）とキーボード操作（focus-visible）を確認する

## Verification
幅 360/768/1280px で崩れず、W3C バリデータ/ Lighthouse のアクセシビリティ指摘が無い

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. npx html-validate / npx stylelint で静的検査する
2. ブラウザ操作不可なら Playwright でスクリーンショットを取得
3. CSS 競合は詳細度を確認し !important に頼らず構造で解決

## Related
frontend, react, charting

## Prohibited
- !important の乱用やインライン style の多用をしない
- 外部 CDN の未検証スクリプトを追加しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
