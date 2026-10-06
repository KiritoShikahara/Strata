---
name: mcp
description: MCP サーバーの導入・設定・接続確認
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
    - MCP
    - Model Context Protocol
    - mcp server
    - ツール連携
    required_tools:
    - terminal
    - read_file
    - patch
    optional_tools:
    - web_search
    dependencies:
    - node
    - npx
    - uvx
    conflicts: []
    workflow: see '## Procedure'
    verification: ツール一覧に MCP のツールが現れ、読み取り系を 1 回正常に呼べる
    fallback:
    - npx 不在は winget install OpenJS.NodeJS.LTS、uvx 不在は pip install uv
    - 起動失敗は同コマンドを terminal で直接実行しエラー確認
    - サーバー不可は同等機能を CLI ラッパーで代替
    risk_level: medium
    related:
    - agent-design
    - tool-router
    - permission-policy
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# mcp

MCP サーバーの導入・設定・接続確認

## When to Use
Trigger: MCP, Model Context Protocol, mcp server, ツール連携

## Tools
- required: terminal, read_file, patch
- optional: web_search
- dependencies: node, npx, uvx（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. %LOCALAPPDATA%\hermes\config.yaml の mcp_servers 節を確認する
2. 公式/信頼できるサーバーを選定し npx -y <pkg> や uvx <pkg> で単体起動を試す
3. config.yaml に command・args・env を追記(Secret は環境変数参照)
4. Hermes 再起動後、公開されたツール一覧を確認し 1 件呼び出して動作確認

## Verification
ツール一覧に MCP のツールが現れ、読み取り系を 1 回正常に呼べる

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. npx 不在は winget install OpenJS.NodeJS.LTS、uvx 不在は pip install uv
2. 起動失敗は同コマンドを terminal で直接実行しエラー確認
3. サーバー不可は同等機能を CLI ラッパーで代替

## Related
agent-design, tool-router, permission-policy

## Prohibited
- 未検証の MCP パッケージを承認なしで導入しない
- API キーを config に平文で書かない・出力しない
- 書込み/削除系ツールの許可を承認なしで与えない
- Approval 対象（permission-policy 参照）は実行前に確認する。
