---
name: prompt-engineering
description: プロンプトを設計・改善し出力品質を安定させる
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - ai
    category: ai
  kiridev:
    namespace: kiridev
    category: ai
    triggers:
    - プロンプト
    - 指示文
    - few-shot
    - 出力形式
    required_tools:
    - read_file
    - write_file
    optional_tools:
    - terminal
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 評価入力セットで形式遵守率・正答率が改善している
    fallback:
    - 形式不安定は response_format / JSON schema 制約や grammar(--grammar-file)を使う
    - 小モデルで限界なら model-router で上位モデルへ
    - 指示が長すぎるなら分割し段階実行
    risk_level: low
    related:
    - context-engineering
    - model-evaluation
    - skill-authoring
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# prompt-engineering

プロンプトを設計・改善し出力品質を安定させる

## When to Use
Trigger: プロンプト, 指示文, few-shot, 出力形式

## Tools
- required: read_file, write_file
- optional: terminal
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 目的・入力・出力形式(JSON スキーマ等)・禁止事項を明示した指示を書く
2. 小型ローカルモデル向けに短い文・箇条書き・具体例 1〜3 個にする
3. 代表入力 5〜10 件で実行し失敗パターンを分類する
4. 失敗点に対して指示を 1 点ずつ修正し再実行して比較する

## Verification
評価入力セットで形式遵守率・正答率が改善している

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 形式不安定は response_format / JSON schema 制約や grammar(--grammar-file)を使う
2. 小モデルで限界なら model-router で上位モデルへ
3. 指示が長すぎるなら分割し段階実行

## Related
context-engineering, model-evaluation, skill-authoring

## Prohibited
- ガードレール回避を目的とした指示を書かない
- Approval 対象（permission-policy 参照）は実行前に確認する。
