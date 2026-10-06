---
name: subagent-design
description: サブエージェントへの分割・委任と結果統合を設計する
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
    - サブエージェント
    - 並列
    - delegate
    - 委任
    required_tools:
    - delegate_task
    - todo
    optional_tools:
    - read_file
    - write_file
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 各サブタスクの成果物が実在し、統合後にテストが通る
    fallback:
    - 失敗したサブタスクは範囲を絞って再委任
    - 依存が強い場合は委任せず本体で実施
    - ローカルモデルが遅い場合は逐次実行に変更
    risk_level: medium
    related:
    - agent-design
    - model-router
    - checkpoint
    - verification
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# subagent-design

サブエージェントへの分割・委任と結果統合を設計する

## When to Use
Trigger: サブエージェント, 並列, delegate, 委任

## Tools
- required: delegate_task, todo
- optional: read_file, write_file
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 独立して実行できる自己完結タスクのみを切り出す
2. 各依頼に目的・対象パス・完了条件・出力形式を明記して delegate_task
3. 編集対象が重ならないよう担当ファイルを分ける
4. 戻り値を検証(実ファイル確認・テスト)してから統合する

## Verification
各サブタスクの成果物が実在し、統合後にテストが通る

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 失敗したサブタスクは範囲を絞って再委任
2. 依存が強い場合は委任せず本体で実施
3. ローカルモデルが遅い場合は逐次実行に変更

## Related
agent-design, model-router, checkpoint, verification

## Prohibited
- サブエージェントに Secret を渡さない
- 結果を未検証で完了扱いにしない
- 破壊的操作を委任しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
