---
name: multi-agent
description: 複数エージェントの役割分担と統合で大規模作業を進める
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
    - マルチエージェント
    - 役割分担
    - 並列エージェント
    - kanban
    required_tools:
    - delegate_task
    - todo
    optional_tools:
    - terminal
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 統合後に全テスト通過、担当範囲の重複編集が無い (git diff --stat)
    fallback:
    - 競合多発 → 直列化
    - エージェント失敗 → 再割当/自分で実行
    risk_level: medium
    related:
    - subagent-delegation
    - workflow-orchestration
    - git-worktree
    - independent-review
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# multi-agent

複数エージェントの役割分担と統合で大規模作業を進める

## When to Use
Trigger: マルチエージェント, 役割分担, 並列エージェント, kanban

## Tools
- required: delegate_task, todo
- optional: terminal
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 作業を独立単位に分け、役割（調査/実装/レビュー）と担当ファイル範囲を定義
2. kanban/todo にタスクと担当を登録し、衝突を避けるため担当ファイルを分離（git-worktree 併用）
3. 各エージェントへ自己完結のプロンプトを渡し並列起動 (parallel-execution)
4. 成果を統合し independent-review で相互検証
5. 競合・重複を解消して最終テスト

## Verification
統合後に全テスト通過、担当範囲の重複編集が無い (git diff --stat)

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 競合多発 → 直列化
2. エージェント失敗 → 再割当/自分で実行

## Related
subagent-delegation, workflow-orchestration, git-worktree, independent-review

## Prohibited
- 同一ファイルを複数エージェントが同時編集しない
- 承認対象操作を子に任せない
- Approval 対象（permission-policy 参照）は実行前に確認する。
