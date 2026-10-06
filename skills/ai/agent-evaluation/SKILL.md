---
name: agent-evaluation
description: エージェントのタスク完遂率・安全性を評価する
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
    - エージェント評価
    - 成功率
    - タスク完遂
    - 回帰
    required_tools:
    - terminal
    - write_file
    - read_file
    optional_tools:
    - delegate_task
    dependencies:
    - python
    conflicts: []
    workflow: see '## Procedure'
    verification: タスク別の合否表があり、再実行で同じ判定になる
    fallback:
    - 自動判定不能なタスクはトレースを人手レビュー
    - ばらつきが大きい場合は各タスク 3 回実行して平均
    - 環境汚染時は新規ディレクトリで再実行
    risk_level: low
    related:
    - tool-use-evaluation
    - model-evaluation
    - testing
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# agent-evaluation

エージェントのタスク完遂率・安全性を評価する

## When to Use
Trigger: エージェント評価, 成功率, タスク完遂, 回帰

## Tools
- required: terminal, write_file, read_file
- optional: delegate_task
- dependencies: python（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 代表タスク(読取/編集/検索/失敗復旧)を成功条件付きで evals\agent_tasks.yaml に定義
2. 隔離した作業ディレクトリでエージェントを実行しトレースを保存
3. 成功条件を自動判定(ファイル内容・終了コード)し、ステップ数・時間を記録
4. 失敗の原因(誤ツール/ループ/幻覚)を分類し改善点にする

## Verification
タスク別の合否表があり、再実行で同じ判定になる

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 自動判定不能なタスクはトレースを人手レビュー
2. ばらつきが大きい場合は各タスク 3 回実行して平均
3. 環境汚染時は新規ディレクトリで再実行

## Related
tool-use-evaluation, model-evaluation, testing

## Prohibited
- 実データ・本番環境でテストしない
- 外部送信を伴うタスクを評価に含めない
- Approval 対象（permission-policy 参照）は実行前に確認する。
