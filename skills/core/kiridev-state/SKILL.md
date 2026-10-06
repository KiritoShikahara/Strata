---
name: kiridev-state
description: タスク/ルート/Fallback/検証結果を SQLite に記録・参照する
version: 1.0.0
metadata:
  hermes:
    tags: [kiridev, core, logging]
    category: core
  kiridev:
    namespace: kiridev
    category: core
    triggers: [記録, ログ, 履歴, ベンチマーク結果, 何を試したか]
    required_tools: [terminal]
    optional_tools: []
    dependencies: [python]
    conflicts: []
    workflow: see '## Procedure'
    verification: "kdlog.py tail で記録した行が表示される"
    fallback: [python が無い場合は .kiridev/log.jsonl に 1 行 JSON を追記]
    risk_level: low
    source: hand-written
---

# kiridev-state

Runtime State は SQLite（`%LOCALAPPDATA%\hermes\kiridev\state.db`）。定義（Skill/Policy）は git 管理の Markdown/YAML。
Hermes 自身の会話・tool 実行履歴は `%LOCALAPPDATA%\hermes\state.db`（`session_search` で参照）にあるので重複記録しない。

## Procedure
`python %LOCALAPPDATA%\hermes\skills\core\kiridev-state\scripts\kdlog.py <cmd>`
- 記録: `event <kind> <name> [--result ok|fail|skip] [--detail TEXT] [--project PATH]`
  kind = task | tool | route | fallback | failure | verify | skill | checkpoint | benchmark
- 参照: `tail [-n 20] [--kind fallback]`、集計: `stats`

## When to record
- model route を変えた / fallback を発動した / 検証結果（/verify）/ checkpoint / benchmark 数値。
- 毎ツール呼び出しは記録しない（Hermes が既に記録）。
