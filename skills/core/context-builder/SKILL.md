---
name: context-builder
description: 必要最小限の Context を組み立て、溢れたら要約・分割する
version: 1.0.0
metadata:
  hermes:
    tags: [kiridev, core, context]
    category: core
  kiridev:
    namespace: kiridev
    category: core
    triggers: [大きいリポジトリ, 長い会話, context-overflow, 大きいログ/ファイル]
    required_tools: [search_files, read_file]
    optional_tools: [delegate_task, session_search, memory, todo]
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 読んだファイルが課題に直接関係し、context 使用率が過大でない（/usage）
    fallback: [Relevant file retrieval → 要約 → retrieval → task split → subagent → state 保存 → 継続]
    risk_level: low
    source: hand-written
---

# context-builder

## Procedure
1. **Project 把握**: `AGENTS.md`/`README.md`/ビルド定義（CMakeLists.txt, *.sln, package.json, pyproject.toml, *.uproject, ProjectSettings/）だけ先に読む。
2. **Relevant file retrieval**: `search_files`（rg）でシンボル・エラー文字列を検索し、該当範囲だけ `read_file`（offset/limit）で読む。ファイル全体を読まない。
3. **ログ**: 末尾・エラー行周辺だけ（`Select-String -Context 3,3`、`Get-Content -Tail 200`）。
4. **Context Overflow 時**（Failure Class: context-overflow）:
   a. 不要な履歴を `/compress`（Hermes compression が自動でも動く）
   b. 調査を `delegate_task` の子に任せ要約だけ受け取る
   c. タスクを分割し `todo` に記録
   d. 状態を `.kiridev/checkpoint.md`（checkpoint Skill）に保存して継続
5. 過去セッションの情報は `session_search`、恒久的な事実は `memory`。

## Prohibited
- 巨大ファイル・バイナリ・node_modules を丸ごと読むこと。
