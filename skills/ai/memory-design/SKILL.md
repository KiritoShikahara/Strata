---
name: memory-design
description: エージェントの記憶(短期/長期)の保存方針を設計する
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
    - 記憶設計
    - memory
    - 長期記憶
    - 保存方針
    required_tools:
    - memory
    - read_file
    optional_tools:
    - session_search
    - write_file
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 保存した記憶が新規セッションで検索・参照できる
    fallback:
    - memory 不可は notes\memory.md ファイルで代替
    - 肥大化は context-compression で要約統合
    - 矛盾する記憶は新しい根拠のものを優先し旧版を更新
    risk_level: low
    related:
    - context-compression
    - agent-design
    - session_search
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# memory-design

エージェントの記憶(短期/長期)の保存方針を設計する

## When to Use
Trigger: 記憶設計, memory, 長期記憶, 保存方針

## Tools
- required: memory, read_file
- optional: session_search, write_file
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 保存対象を「恒久の好み/プロジェクト事実/一時メモ」に分類する
2. 恒久事項のみ memory に 1 事実 1 エントリで保存、日付と根拠を付与
3. session_search で過去会話の再利用可否を確認し、重複保存を避ける
4. 古い・誤った記憶の更新/削除手順を決める

## Verification
保存した記憶が新規セッションで検索・参照できる

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. memory 不可は notes\memory.md ファイルで代替
2. 肥大化は context-compression で要約統合
3. 矛盾する記憶は新しい根拠のものを優先し旧版を更新

## Related
context-compression, agent-design, session_search

## Prohibited
- パスワード・トークン・個人情報を記憶に保存しない
- 記憶の一括削除を承認なしで行わない
- Approval 対象（permission-policy 参照）は実行前に確認する。
