---
name: kiri-handoff
description: 別PC/別Session向けに作業状態を記録し commit/push（/handoff 相当）
version: 1.0.0
metadata:
  hermes:
    tags: [kiridev, workflow, handoff]
    category: workflow
  kiridev:
    namespace: kiridev
    category: workflow
    triggers: [/kiri-handoff, 引き継ぎ, 別PCで続ける, 作業を保存して終わる]
    required_tools: [terminal, write_file]
    optional_tools: []
    dependencies: [git]
    conflicts: [Hermes built-in /handoff（messaging platform への引き継ぎ。別機能）]
    workflow: see '## Procedure'
    verification: .handoff/HANDOFF.md が全項目を含み、commit hash と push 結果を報告した
    fallback: [push 拒否 → 報告して停止（merge/rebase しない）、remote 無し → commit のみ]
    risk_level: medium
    source: hand-written
---

# kiri-handoff

Hermes の `/handoff` は「CLI セッションを Telegram 等へ渡す」built-in のため、KiriDev の引き継ぎは `/kiri-handoff`。
再開側は `/pull` → `/pickup`。

## Procedure
1. `git status -sb`、`git diff HEAD --stat`、`git log --oneline -5`、`git stash list`、直近の build/test 結果を確認。
2. `.handoff/HANDOFF.md` を上書き（日本語）。必須項目:
   ```
   # 引き継ぎ (<YYYY-MM-DD HH:MM> / <branch>)
   次の一手: <最初にやる具体的な 1 アクション>
   ## Goal
   ## 現在の状態
   ## 完了タスク (file:line / commit)
   ## 残りタスク（優先順・最大5）
   ## 重要ファイル
   ## 決定事項（理由つき）
   ## Branch / 関連コミット
   ## Build 状態 / Test 状態
   ## 既知の問題
   ## 再開に必要なもの（導入コマンド、環境変数は名前のみ、git 外のファイル）
   ```
   引数（コマンド後ろの指示）があれば `## メモ` に追加。`.kiridev/checkpoint.md` があれば内容を反映。
3. Secret（.env*, 鍵, トークン）と build/cache 出力は stage しない。必要なら .gitignore に追加し「再開に必要なもの」に名前だけ記載。
4. `git add -A`（除外分を除く）→ `git commit -m "chore: handoff <要約>"`（直近コミットの書式に合わせる）。
5. `git push`（upstream 無しなら `git push -u origin <branch>`）。force push 禁止。拒否されたら報告して停止。
6. 2〜3 行で報告: commit hash、push 結果、再開手順（`/pull` → `/pickup`）。
