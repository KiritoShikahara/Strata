---
name: fallback
description: 失敗を分類し代替経路で再試行する汎用 Fallback Engine
version: 1.0.0
metadata:
  hermes:
    tags: [kiridev, core, fallback]
    category: core
  kiridev:
    namespace: kiridev
    category: core
    triggers: [コマンドが見つからない, エラー, 失敗, 権限エラー, 形式非対応, タイムアウト, できない]
    required_tools: [terminal]
    optional_tools: [web_search, delegate_task]
    dependencies: [powershell]
    conflicts: []
    workflow: see '## Procedure'
    verification: 代替経路の結果を元の完了条件で再検証した
    fallback: [Escalate only when necessary（model-router / ユーザー介入）]
    risk_level: medium
    source: hand-written
---

# fallback

「できない」で即終了しない。Task → Primary Route → Execute → Verify → Failure → **Classify** → Alternative Route → Retry → Verify → 必要時のみ Escalate。

## Failure Class → 代替経路
| class | 代替経路 |
|---|---|
| tool-missing / dependency-missing | 下記 Tool Missing 経路 |
| tool-crash | 引数/入力を最小化して再現 → 別バージョン → 代替ツール |
| unsupported-format | 変換（pandoc/soffice/ffmpeg）→ universal-document-ingestion |
| permission-denied | 対象の ACL 確認（`icacls`）→ ユーザースコープの代替パス → 管理者が必要なら permission-policy |
| network-failure | 再試行（指数待機 3 回）→ proxy/DNS 確認（network-diagnostics）→ ミラー/キャッシュ |
| authentication-required | 認証不要の経路 → ユーザーに認証手順を提示（Secret は聞き出さない） |
| parser-incomplete | OOXML 直接解析 → レンダリング + vision → OCR |
| vision-required | vision_analyze（model-router の vision route） |
| model-capability-gap | fallback-model-routing |
| context-overflow | context-builder |
| build-failure / test-failure | debugging（/diagnose 手順）|
| environment-drift | doctor |
| workspace-corruption | `git status`/`git fsck` → checkpoint/rollback（/rollback）|
| remote-node-unavailable | 疎通確認（`Test-NetConnection`）→ ローカル実行に切替 |
| rate-limit | 待機 → Hermes fallback_providers → 別 provider |
| unknown | 最小再現を作り、エラー文で web_search → 仮説検証 |

## Tool Missing 経路（自動で進める）
1. `powershell -File <this skill>/scripts/find-tool.ps1 <name>` — PATH / よくある導入先 / winget 一覧を一括検索。
   （Hermes skills dir: `%LOCALAPPDATA%\hermes\skills\core\fallback\scripts\find-tool.ps1`）
2. 見つかれば PATH 未登録でもフルパスで使う。
3. 無ければ: `winget install -e --id <Id> --scope user`（ID は `winget search`）→ `pip install --user` / `npm i -g` → portable（zip を `%LOCALAPPDATA%\Programs` に展開）
   → Docker（`docker run --rm -v ${PWD}:/w <image>`）→ WSL（`wsl -e <cmd>`）→ 代替ツール → ユーザー介入。
4. 導入後 `Get-Command` で確認し、元のタスクを再実行。

## Procedure
1. エラー文・exit code をそのまま記録。
2. 上表で class を決める（複数なら最初に起きたもの）。
3. 代替経路を 1 つずつ試し、各回 Verify。同じ方法を 3 回以上繰り返さない。
4. 成功/失敗を `kdlog.py event fallback --name <class> --result ok|fail --detail <route>` で記録。
5. すべて失敗したら、試した経路・結果・次の候補を添えて報告（Escalate）。

## Prohibited
- 失敗を握りつぶして成功と報告すること。テストを弱めて通すこと。
