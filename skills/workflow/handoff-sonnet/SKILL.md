---
name: handoff-sonnet
description: 設計まで行い Claude Sonnet コンソールへ実装を引き継ぐ
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - workflow
    category: workflow
  kiridev:
    namespace: kiridev
    category: workflow
    triggers:
    - /handoff-sonnet
    - Sonnet に引き継ぎ
    required_tools:
    - terminal
    - write_file
    optional_tools:
    - delegate_task
    dependencies:
    - git
    conflicts: []
    workflow: see body
    verification: HANDOFF.md 作成とコンソール起動結果を報告
    fallback:
    - fallback Skill（Failure Class 別の代替経路）
    risk_level: medium
    source: ported from qwen-skills/handoff-sonnet
---

# handoff-sonnet

対象: **（コマンド引数）**

引数が空なら、会話中の直近の機能依頼を対象にする。それもなければ何を作るかを1行で質問して止まる。

## 1. 設計まで行う（Opus の仕事）

1. リポジトリに `.specify/` があるか確認する。なければ Spec Kit が未導入と伝え、導入してよいか確認する（勝手に導入しない）。
2. `speckit-require` スキルの手順を最後まで実行し、`spec.md → plan.md → tasks.md` を生成・更新する。
   - clarify では要件の曖昧点を質問してよい（最大5問、選択肢つき）。ユーザーはまだ Opus 側にいる。
   - plan.md には設計（構成・データモデル・インタフェース・採用技術と理由）を必ず含める。
   - tasks.md は Sonnet が迷わず実装できる粒度に分解する: 1タスク1つの検証可能な作業、対象ファイルパス、完了条件（実行するテスト/コマンド）を書く。テストタスクを含める。
3. **実装はしない**。コードの変更は Sonnet に任せる。

## 2. 引き継ぎメモを書く

`.handoff/HANDOFF.md` を作成（フォルダがなければ作る、既存は上書き）。日本語で、次の形にする。空のセクションは省く。

```
# 引き継ぎ (<YYYY-MM-DD HH:MM> / Opus → Sonnet)

次の一手: <tasks.md の最初のタスク番号と内容>

## 仕様
- spec: <spec.md のパス>
- plan: <plan.md のパス>
- tasks: <tasks.md のパス>（上から順に実装、各タスクは検証してからチェック）
## 設計の要点（最大5件）
- ...
## 実装時の注意
- <落とし穴、守るべき規約、触ってはいけない箇所>
## 保留
- <task> — <何待ちか>
```

- git の commit / push はしない（GitHub を介さない引き継ぎ）。

## 3. Sonnet のコンソールを起動する

プロジェクトのルートで次を実行する（新しいウィンドウで開き、このセッションはブロックしない）:

```
cmd.exe /c start "" "<このスキルのフォルダ>\launch.cmd" "<プロジェクトのルートの絶対パス>"
```

- `<このスキルのフォルダ>` は `%LOCALAPPDATA%\hermes\skills\workflow\handoff-sonnet`（KiriDev sync 先）。
- `launch.cmd` はプロジェクト直下の `claude-1-ultra-sonnet-adhd.cmd` を優先し、なければ ctx-kit の `claude-1-ultra.cmd` を Sonnet + ADHD で直接起動する。
- 起動に失敗したら、エラー文と手動の起動手順（`claude-1-ultra-sonnet-adhd.cmd` をプロジェクトで実行）を報告する。

## 4. 報告（2〜3行）

1行目: 「新しいコンソールで `/pickup` を打つと Sonnet が tasks.md の最初から実装を始める」。
続けて: spec/plan/tasks のパス、タスク数、起動結果。
