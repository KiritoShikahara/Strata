---
name: goal-driven-autonomy
description: /goal の達成条件に向けて自律的に計画・実行・検証
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
    - ゴール
    - goal
    - 目標達成まで
    - overnight-goal
    required_tools:
    - terminal
    - todo
    optional_tools:
    - delegate_task
    - memory
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 達成条件が実コマンド出力で検証済み、todo が全て完了/理由付き未完
    fallback:
    - 条件が曖昧 → 解釈を明記して clarify
    - 達成不能 → 到達点と阻害要因を報告
    - 長時間化 → long-running-task へ
    risk_level: medium
    related:
    - overnight-autonomy
    - verification
    - failure-recovery
    - task-prioritization
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# goal-driven-autonomy

/goal の達成条件に向けて自律的に計画・実行・検証

## When to Use
Trigger: ゴール, goal, 目標達成まで, overnight-goal

## Tools
- required: terminal, todo
- optional: delegate_task, memory
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. /goal（夜間は /overnight-goal）で達成条件を測定可能な形に明文化
2. サブタスクへ分解し todo 管理、依存順で実行
3. 各ステップ後にテスト/コマンドで進捗を検証し、ゴールとの差分を再評価
4. 失敗は failure-recovery で別経路へ、同一失敗の繰返しは3回で打切り
5. 達成条件の検証結果をもって完了宣言

## Verification
達成条件が実コマンド出力で検証済み、todo が全て完了/理由付き未完

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 条件が曖昧 → 解釈を明記して clarify
2. 達成不能 → 到達点と阻害要因を報告
3. 長時間化 → long-running-task へ

## Related
overnight-autonomy, verification, failure-recovery, task-prioritization

## Prohibited
- 達成条件を勝手に緩めない
- 承認対象操作を目標のためでも無断実行しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
