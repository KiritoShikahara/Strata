---
name: story-writing
description: 物語・キャラクター・台詞の執筆と構成
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - creative
    category: creative
  kiridev:
    namespace: kiridev
    category: creative
    triggers:
    - 物語
    - シナリオ
    - 台詞
    - キャラクター設定
    - プロット
    - 小説
    required_tools:
    - read_file
    - write_file
    optional_tools:
    - clarify
    - web_search
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: アウトラインの全ビートが本文に対応し、設定矛盾リストが 0 件
    fallback:
    - 情報不足は複数案（短いあらすじ）を提示して選んでもらう
    - 長編は章ごとに分割して保存し要約で整合を保つ
    - 参考は research で調べるが文章は模倣しない
    risk_level: low
    related:
    - game-design
    - creative-direction
    - level-design
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# story-writing

物語・キャラクター・台詞の執筆と構成

## When to Use
Trigger: 物語, シナリオ, 台詞, キャラクター設定, プロット, 小説

## Tools
- required: read_file, write_file
- optional: clarify, web_search
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. ジャンル・トーン・対象読者・分量を確認し不明点は clarify で質問する
2. 前提（世界観・主人公の欲求と障害・結末）を 1 ページの設定書にまとめる
3. 三幕構成/ビート表でアウトラインを作る
4. 場面ごとに執筆し、キャラごとの口調差分を style guide で保つ
5. 一貫性（時系列・固有名詞・設定）を校閲し Markdown で保存する

## Verification
アウトラインの全ビートが本文に対応し、設定矛盾リストが 0 件

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 情報不足は複数案（短いあらすじ）を提示して選んでもらう
2. 長編は章ごとに分割して保存し要約で整合を保つ
3. 参考は research で調べるが文章は模倣しない

## Related
game-design, creative-direction, level-design

## Prohibited
- 既存作品の文章・キャラの無断流用をしない
- 作品の外部公開・投稿・送信は承認なしで行わない
- Approval 対象（permission-policy 参照）は実行前に確認する。
