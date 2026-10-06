---
name: subagent-delegation
description: delegate_task でサブエージェントへ作業を委譲
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
    - サブエージェント
    - 委譲
    - delegate
    - 子エージェント
    required_tools:
    - delegate_task
    optional_tools:
    - read_file
    - todo
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 委譲結果の主要点を独立に再確認し、完了条件を満たしている
    fallback:
    - 委譲失敗 → タスクを分割して再委譲
    - 失敗継続 → 自分で実行
    risk_level: low
    related:
    - multi-agent
    - parallel-execution
    - model-router
    - independent-review
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# subagent-delegation

delegate_task でサブエージェントへ作業を委譲

## When to Use
Trigger: サブエージェント, 委譲, delegate, 子エージェント

## Tools
- required: delegate_task
- optional: read_file, todo
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 委譲対象を選定（大規模探索・独立タスク・並列可能なもの）。小さい作業は自分で行う
2. goal・対象パス・完了条件・出力形式を自己完結で記述（子は文脈を持たない）
3. 重要度に応じてモデル選択 (model-router)、調査系は readonly
4. 結果を鵜呑みにせず、主要な主張を自分でコマンド/ファイル確認
5. 統合して報告

## Verification
委譲結果の主要点を独立に再確認し、完了条件を満たしている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 委譲失敗 → タスクを分割して再委譲
2. 失敗継続 → 自分で実行

## Related
multi-agent, parallel-execution, model-router, independent-review

## Prohibited
- Secret・認証情報を子に渡さない
- 子に承認対象操作を任せない
- 結果を未検証で採用しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
