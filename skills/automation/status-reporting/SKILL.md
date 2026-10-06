---
name: status-reporting
description: 進捗・結果・未完事項を簡潔で正確に報告
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
    - 進捗報告
    - ステータス
    - 報告
    - 状況まとめ
    required_tools:
    - todo
    optional_tools:
    - terminal
    - read_file
    dependencies:
    - git
    conflicts: []
    workflow: see '## Procedure'
    verification: 報告内の完了項目すべてに検証証跡があり、未検証は明記されている
    fallback:
    - 長時間ジョブ → ログ tail で最新状態を取得してから報告
    - 情報欠落 → 不明と明記
    risk_level: low
    related:
    - verification
    - task-resume
    - long-running-task
    - overnight-autonomy
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# status-reporting

進捗・結果・未完事項を簡潔で正確に報告

## When to Use
Trigger: 進捗報告, ステータス, 報告, 状況まとめ

## Tools
- required: todo
- optional: terminal, read_file
- dependencies: git（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. todo と git diff --stat / テスト結果から事実を収集
2. 完了・進行中・ブロック・要承認 に分類
3. 各項目に証跡 (file:line, コマンド結果) を付与
4. 次のアクションと所要の判断をユーザー向けに 1-4 行で提示

## Verification
報告内の完了項目すべてに検証証跡があり、未検証は明記されている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 長時間ジョブ → ログ tail で最新状態を取得してから報告
2. 情報欠落 → 不明と明記

## Related
verification, task-resume, long-running-task, overnight-autonomy

## Prohibited
- 未検証を完了と報告しない
- 失敗を隠さない
- Secret を報告に含めない
- 外部への報告送信は承認なしにしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
