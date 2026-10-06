---
name: task-prioritization
description: タスクを緊急度・重要度・依存で優先順位付け (/priorities)
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - automation
    category: automation
  kiridev:
    namespace: kiridev
    category: automation
    triggers:
    - 優先順位
    - 優先度
    - priorities
    - 何からやる
    required_tools:
    - todo
    optional_tools:
    - memory
    - terminal
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 各タスクに順位と根拠があり、依存関係が矛盾しない
    fallback:
    - 情報不足 → 前提を明記して暫定順位 + clarify
    - todo 空 → git log / 未完了ファイルから候補抽出
    risk_level: low
    related:
    - task-resume
    - workflow-orchestration
    - status-reporting
    - goal-driven-autonomy
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# task-prioritization

タスクを緊急度・重要度・依存で優先順位付け (/priorities)

## When to Use
Trigger: 優先順位, 優先度, priorities, 何からやる

## Tools
- required: todo
- optional: memory, terminal
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. todo と進行中案件を集め、期限・影響・工数・依存・ブロッカーを整理
2. 重要度×緊急度で分類し、依存順とクイックウィンを加味して並べる
3. /priorities で上位 3 件と理由を提示
4. 状況変化があれば再評価

## Verification
各タスクに順位と根拠があり、依存関係が矛盾しない

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 情報不足 → 前提を明記して暫定順位 + clarify
2. todo 空 → git log / 未完了ファイルから候補抽出

## Related
task-resume, workflow-orchestration, status-reporting, goal-driven-autonomy

## Prohibited
- ユーザーの明示優先度を無断で覆さない
- 期限を推測で断定しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
