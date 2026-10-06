---
name: tool-router
description: タスクに必要なツールだけを選び、無ければ導入・代替する
version: 1.0.0
metadata:
  hermes:
    tags: [kiridev, core, router]
    category: core
  kiridev:
    namespace: kiridev
    category: core
    triggers: [ツール選択, 外部コマンドが必要, MCP ツールが多い]
    required_tools: [terminal]
    optional_tools: [execute_code, browser_navigate, web_search, delegate_task]
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 使ったツールが実在し（Get-Command 成功）、目的の出力を返した
    fallback: [fallback Skill の tool-missing 経路]
    risk_level: low
    source: hand-written
---

# tool-router

Permission が広いこと（Default Allow）と、毎回全ツールを Context に公開することは別。必要なツールだけを使う。

## Procedure
1. **Hermes 組み込みを優先**: ファイル=read_file/write_file/patch/search_files、シェル=terminal、Web=web_search/web_extract、
   ブラウザ=browser_*、画像=vision_analyze、並列/重い調査=delegate_task、計画=todo。
2. **MCP / plugin ツールが多い場合**は Hermes Tool Search（tool_search → tool_describe → tool_call）で必要なものだけ読む。
   toolset を絞りたい時は `hermes chat -t terminal,file,web` のように起動する。
3. **外部 CLI**: 使う前に `Get-Command <tool> -ErrorAction SilentlyContinue` で存在確認。
   無ければ `fallback` Skill の tool-missing 経路（PATH 探索 → winget/pip/npm → portable → Docker/WSL → 代替ツール）。
4. **シェル選択**: Windows では PowerShell を既定。bash 前提スクリプトは Git Bash か WSL。
5. 長時間プロセスは terminal の background + process で監視し、ハングさせない。

## Verification
コマンドの exit code と出力を確認してから次に進む。

## Prohibited
- 存在確認せずにツール名を推測で実行し続けること。
- permission-policy の Approval 対象操作をツール経由で無確認実行すること。
