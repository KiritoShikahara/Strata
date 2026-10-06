---
name: browser-automation
description: ブラウザ操作で Web ページを閲覧・操作する
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - research
    category: research
  kiridev:
    namespace: kiridev
    category: research
    triggers:
    - ブラウザ操作
    - クリック
    - スクレイピング
    - ログイン後
    required_tools:
    - browser_navigate
    - browser_snapshot
    - browser_click
    - browser_type
    optional_tools:
    - browser_vision
    - terminal
    dependencies:
    - playwright
    conflicts: []
    workflow: see '## Procedure'
    verification: 最終 snapshot に目的の要素・テキストが存在する
    fallback:
    - ref が古い場合は snapshot を取り直す
    - ブラウザ未導入は npx playwright install chromium
    - CAPTCHA・2FA は止めてユーザーに引き渡す
    - Playwright 不可は web_extract か Invoke-WebRequest で静的取得
    risk_level: medium
    related:
    - form-interaction
    - site-navigation
    - download-management
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# browser-automation

ブラウザ操作で Web ページを閲覧・操作する

## When to Use
Trigger: ブラウザ操作, クリック, スクレイピング, ログイン後

## Tools
- required: browser_navigate, browser_snapshot, browser_click, browser_type
- optional: browser_vision, terminal
- dependencies: playwright（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. browser_navigate で URL を開き browser_snapshot で要素 ref を取得する
2. browser_click / browser_type を ref 指定で実行し、都度 snapshot で状態確認
3. 動的描画や画像要素は browser_vision で視覚確認する
4. 必要データを抽出し、取得元 URL と共に保存する

## Verification
最終 snapshot に目的の要素・テキストが存在する

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. ref が古い場合は snapshot を取り直す
2. ブラウザ未導入は npx playwright install chromium
3. CAPTCHA・2FA は止めてユーザーに引き渡す
4. Playwright 不可は web_extract か Invoke-WebRequest で静的取得

## Related
form-interaction, site-navigation, download-management

## Prohibited
- パスワード・トークンを推測入力しない
- 購入・送信・投稿ボタンを承認なしで押さない
- CAPTCHA 回避をしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
