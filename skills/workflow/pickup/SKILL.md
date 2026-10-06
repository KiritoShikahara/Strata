---
name: pickup
description: 引き継ぎ/Checkpoint/git から現在地を復元し作業を再開
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
    - /pickup
    - 再開
    - 続きから
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - delegate_task
    dependencies:
    - git
    conflicts: []
    workflow: see body
    verification: 再開タスクが特定され着手している
    fallback:
    - fallback Skill（Failure Class 別の代替経路）
    risk_level: low
    source: ported from qwen-skills/pickup
---

# pickup

中断した作業を再開する。ヒント: **（コマンド引数）**（空なら全体から判断する）

## 1. 現在地を復元する（ユーザーに質問する前に自分で調べる）

次の手がかりを並行して確認する。存在しないものは飛ばす。

- この会話の履歴と、タスク／プラン機能の未完了項目
- `git status -sb`、`git log --oneline -10`、`git stash list`、未コミット差分の概要
- `TODO.md` / `TASKS.md` / `specs/**/tasks.md` などの未チェック項目（`- [ ]`）
- `.handoff/HANDOFF.md`（別PCで `/kiri-handoff` が残した引き継ぎメモ。あれば最優先で読む）
- 直前の `/overnight` 報告などにある「残タスク」「保留理由」
- 失敗しているテスト・ビルド（あれば最小のコマンドで確認）

（コマンド引数） が指定されていれば、それに関係するものを優先する。

## 2. 現在地を短く示す

以下だけを、この順で出す。前置きは書かない。

```
再開: <これから再開するタスク 1件>
現在地: <N 件中 M 件完了 / 最後に終わったこと>
残り: <未完了タスク 最大5件、優先順>
保留: <ユーザー入力・承認待ちのもの（あれば）>
```

## 3. そのまま再開する

- 「再開」に書いた1件にすぐ着手する。「始めますか？」とは聞かない。
- 着手してよいのは、これまでの依頼・承認の範囲のタスクだけ。範囲外のもの、承認待ちのもの、破壊的・外部向けの操作（削除・force push・公開・送信・課金）は「保留」に回し、実行しない。
- 1件終えるごとに検証（テスト／ビルド）し、次の未完了タスクへ進む。
- 手がかりが矛盾していて再開先を決められない場合だけ、候補を2〜3件挙げて1問だけ質問する。

## 4. 区切りでの報告

作業を止めるときは、次の形で報告する。

1. **完了**: 今回終わったこと（`file:line` やコミットIDつき）
2. **残り**: 未完了タスク（次の一手つき）
3. **保留**: 止めている理由

## KiriDev 追加
- `.kiridev/checkpoint.md`（checkpoint Skill）と `kdlog.py tail` も手がかりに含める。引き継ぎメモは `/kiri-handoff` が書く `.handoff/HANDOFF.md`。
