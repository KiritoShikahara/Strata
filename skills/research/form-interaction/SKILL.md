---
name: form-interaction
description: Web フォームを入力し検索・申請操作を行う
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
    - フォーム入力
    - 申込
    - 入力して
    - submit
    required_tools:
    - browser_navigate
    - browser_snapshot
    - browser_type
    - browser_click
    optional_tools:
    - browser_vision
    - clarify
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 送信後の確認画面/メッセージが snapshot に表示されている
    fallback:
    - ref 不一致は snapshot を取り直す
    - カスタム UI で入力不可は browser_vision で座標確認
    - CAPTCHA・本人認証は停止してユーザーへ引き渡す
    risk_level: high
    related:
    - browser-automation
    - site-navigation
    - permission-policy
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# form-interaction

Web フォームを入力し検索・申請操作を行う

## When to Use
Trigger: フォーム入力, 申込, 入力して, submit

## Tools
- required: browser_navigate, browser_snapshot, browser_type, browser_click
- optional: browser_vision, clarify
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. browser_snapshot でフォーム項目の ref・必須項目・選択肢を把握する
2. 入力値をユーザー指定内容と照合し、不足は clarify で確認する
3. browser_type / browser_click で入力し、送信前に snapshot で入力内容を再確認
4. 送信が不可逆なものはユーザー承認後にのみ実行し、結果画面を確認

## Verification
送信後の確認画面/メッセージが snapshot に表示されている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. ref 不一致は snapshot を取り直す
2. カスタム UI で入力不可は browser_vision で座標確認
3. CAPTCHA・本人認証は停止してユーザーへ引き渡す

## Related
browser-automation, site-navigation, permission-policy

## Prohibited
- 承認なしの送信・問い合わせ・購入・予約・投稿
- パスワード/カード情報の入力
- CAPTCHA 回避
- Approval 対象（permission-policy 参照）は実行前に確認する。
