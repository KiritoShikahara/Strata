---
name: tool-use-evaluation
description: ツール呼び出しの正確性・引数妥当性を評価する
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
    - ツール呼び出し
    - function calling
    - tool call 評価
    required_tools:
    - terminal
    - write_file
    optional_tools:
    - execute_code
    dependencies:
    - python
    conflicts: []
    workflow: see '## Procedure'
    verification: 指標(名前一致・JSON 妥当・引数正答)が表で出力されている
    fallback:
    - tool_calls が出ない場合は --jinja とチャットテンプレートを確認
    - 小モデルで不安定ならツール数を減らし説明を簡潔化
    - 改善不能なら model-router で上位モデルへ
    risk_level: low
    related:
    - agent-evaluation
    - mcp
    - llama-cpp
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# tool-use-evaluation

ツール呼び出しの正確性・引数妥当性を評価する

## When to Use
Trigger: ツール呼び出し, function calling, tool call 評価

## Tools
- required: terminal, write_file
- optional: execute_code
- dependencies: python（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. tools スキーマ付きリクエストを /v1/chat/completions に送る(llama-server は --jinja が必要)
2. 期待ツール名・必須引数付きの評価ケースを 20 件前後用意する
3. tool_calls の名前一致率・JSON 妥当性・引数正答率を集計する
4. 失敗は引数欠落/幻覚ツール/不要呼び出しに分類する

## Verification
指標(名前一致・JSON 妥当・引数正答)が表で出力されている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. tool_calls が出ない場合は --jinja とチャットテンプレートを確認
2. 小モデルで不安定ならツール数を減らし説明を簡潔化
3. 改善不能なら model-router で上位モデルへ

## Related
agent-evaluation, mcp, llama-cpp

## Prohibited
- 評価中に破壊的ツールを実際に実行させない
- Approval 対象（permission-policy 参照）は実行前に確認する。
