---
name: skill-evaluation
description: Skill の発火精度と手順の有効性を検証する
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
    - スキル評価
    - 発火
    - trigger 検証
    - skill テスト
    required_tools:
    - read_file
    - terminal
    optional_tools:
    - write_file
    - skill_view
    dependencies:
    - python
    conflicts: []
    workflow: see '## Procedure'
    verification: 正例の選択率が高く負例で誤発火せず、verify を満たす
    fallback:
    - 誤発火が多い場合は tr を具体化し関連 Skill の rel を整理
    - 実行不能な手順は代替(fb)を追記
    - 評価環境が汚れたら新規ディレクトリで再実施
    risk_level: low
    related:
    - skill-authoring
    - agent-evaluation
    - testing
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# skill-evaluation

Skill の発火精度と手順の有効性を検証する

## When to Use
Trigger: スキル評価, 発火, trigger 検証, skill テスト

## Tools
- required: read_file, terminal
- optional: write_file, skill_view
- dependencies: python（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. スキルの tr(Trigger)から代表依頼文を 5 件、非該当依頼を 5 件作る
2. 各依頼で正しい Skill が選ばれるか確認(誤発火・未発火を記録)
3. 手順を実際に実行し verify の条件を満たせるか確認する
4. Trigger・steps・no を修正し再試験する

## Verification
正例の選択率が高く負例で誤発火せず、verify を満たす

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 誤発火が多い場合は tr を具体化し関連 Skill の rel を整理
2. 実行不能な手順は代替(fb)を追記
3. 評価環境が汚れたら新規ディレクトリで再実施

## Related
skill-authoring, agent-evaluation, testing

## Prohibited
- 評価のために破壊的操作を実行しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
