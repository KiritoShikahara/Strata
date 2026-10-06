---
name: x-search
description: X(Twitter) 上の言及・反応を検索して要約する
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
    - X 検索
    - Twitter
    - ツイート
    - 反応
    required_tools:
    - web_search
    - browser_navigate
    optional_tools:
    - browser_snapshot
    - web_extract
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 引用ごとに投稿 URL・投稿者・日時が記載されている
    fallback:
    - ログイン壁は Nitter 系ではなく web_search のスニペットと公式ブログで代替
    - ブラウザ不可は web_extract でポスト URL を直接取得
    - 取得不能なら取得不能と明記し他コミュニティ(community-research)へ
    risk_level: low
    related:
    - community-research
    - source-verification
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# x-search

X(Twitter) 上の言及・反応を検索して要約する

## When to Use
Trigger: X 検索, Twitter, ツイート, 反応

## Tools
- required: web_search, browser_navigate
- optional: browser_snapshot, web_extract
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. web_search で site:x.com <キーワード> を検索する
2. 公開ポストを browser_navigate + browser_snapshot で確認し投稿者・日時を記録
3. 公式アカウント・本人発言と第三者の意見を区別して整理する
4. 重要な主張は source-verification で一次情報と照合する

## Verification
引用ごとに投稿 URL・投稿者・日時が記載されている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. ログイン壁は Nitter 系ではなく web_search のスニペットと公式ブログで代替
2. ブラウザ不可は web_extract でポスト URL を直接取得
3. 取得不能なら取得不能と明記し他コミュニティ(community-research)へ

## Related
community-research, source-verification

## Prohibited
- ログイン・投稿・いいね・DM を承認なしで行わない
- 個人情報を収集・集約しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
