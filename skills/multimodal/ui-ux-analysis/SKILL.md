---
name: ui-ux-analysis
description: UI/UX の課題をヒューリスティックに分析・改善提案する
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - multimodal
    category: multimodal
  kiridev:
    namespace: kiridev
    category: multimodal
    triggers:
    - UI分析
    - UX改善
    - 画面レビュー
    - アクセシビリティ
    required_tools:
    - vision_analyze
    - browser_snapshot
    optional_tools:
    - browser_navigate
    - browser_vision
    - terminal
    dependencies:
    - lighthouse
    conflicts: []
    workflow: see '## Procedure'
    verification: 各課題に重大度・画面箇所・具体的改善案が付いている
    fallback:
    - lighthouse 不可は browser_snapshot のアクセシビリティツリーで確認
    - ブラウザ不可はスクショのみで視覚評価
    - Node 不在は winget install OpenJS.NodeJS.LTS
    risk_level: low
    related:
    - ui-ux-generation
    - screenshot-analysis
    - browser-automation
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# ui-ux-analysis

UI/UX の課題をヒューリスティックに分析・改善提案する

## When to Use
Trigger: UI分析, UX改善, 画面レビュー, アクセシビリティ

## Tools
- required: vision_analyze, browser_snapshot
- optional: browser_navigate, browser_vision, terminal
- dependencies: lighthouse（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 対象画面のスクショまたは URL を取得し vision_analyze で構成を把握
2. Nielsen ヒューリスティック 10 項目と視覚階層・余白・コントラスト比(WCAG 4.5:1)で評価
3. Web なら npx lighthouse <url> --only-categories=accessibility で自動検査
4. 課題を重大度・根拠(画像箇所)・改善案の表にまとめる

## Verification
各課題に重大度・画面箇所・具体的改善案が付いている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. lighthouse 不可は browser_snapshot のアクセシビリティツリーで確認
2. ブラウザ不可はスクショのみで視覚評価
3. Node 不在は winget install OpenJS.NodeJS.LTS

## Related
ui-ux-generation, screenshot-analysis, browser-automation

## Prohibited
- 他者サイトへ負荷をかけるスキャンをしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
