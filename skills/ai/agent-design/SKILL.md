---
name: agent-design
description: エージェントの役割・ツール・制御フローを設計する
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
    - エージェント設計
    - ワークフロー
    - 役割分担
    - 設計
    required_tools:
    - read_file
    - write_file
    optional_tools:
    - todo
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 設計書に成功条件・ツール権限・停止条件・承認点が揃っている
    fallback:
    - 複雑化したら単一エージェント+スキルに簡素化
    - 小モデルで破綻するなら手順を固定化しサブタスク分割
    - 権限が不明なら permission-policy に従い最小権限へ
    risk_level: low
    related:
    - subagent-design
    - memory-design
    - permission-policy
    - mcp
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# agent-design

エージェントの役割・ツール・制御フローを設計する

## When to Use
Trigger: エージェント設計, ワークフロー, 役割分担, 設計

## Tools
- required: read_file, write_file
- optional: todo
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 目的・成功条件・入出力・失敗時挙動を 1 ページで定義する
2. 必要最小限のツールと権限(読取/書込/外部送信)を割り当てる
3. 手順を計画→実行→検証→復旧のループとして記述し停止条件を決める
4. 承認が必要な操作を明示し agent-evaluation で試験する

## Verification
設計書に成功条件・ツール権限・停止条件・承認点が揃っている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 複雑化したら単一エージェント+スキルに簡素化
2. 小モデルで破綻するなら手順を固定化しサブタスク分割
3. 権限が不明なら permission-policy に従い最小権限へ

## Related
subagent-design, memory-design, permission-policy, mcp

## Prohibited
- 承認なしで外部送信・削除できる設計にしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
