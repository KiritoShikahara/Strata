---
name: priorities
description: 未完了タスクを優先度順に表示するだけ（着手しない）
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
    - /priorities
    - 優先順位
    - タスク一覧
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - delegate_task
    dependencies:
    - git
    conflicts: []
    workflow: see body
    verification: 最大5件の表と次の一手が出ている
    fallback:
    - fallback Skill（Failure Class 別の代替経路）
    risk_level: low
    source: ported from qwen-skills/priorities
---

# priorities

タスク一覧を優先度順に表示する。引数: **（コマンド引数）**

**このコマンドは表示だけ。ファイル編集・コミット・タスクへの着手は一切しない。** 調査用の読み取りコマンドだけを使う。

## 1. タスクを集める

次の手がかりを並行して確認する。存在しないものは飛ばす。

- この会話の履歴と、タスク／プラン機能の未完了項目
- `git status -sb`、`git log --oneline -10`、`git stash list`（未コミット・未 push の作業もタスクとして数える）
- `TODO.md` / `TASKS.md` / `specs/**/tasks.md` などの未チェック項目（`- [ ]`）
- `.handoff/HANDOFF.md`（`/kiri-handoff` の引き継ぎメモ）
- 直前の `/overnight`・`/pickup` 報告の「残タスク」「保留」
- 失敗中のテスト・ビルドがすでに分かっていれば、それも含める（重いテストは新たに実行しない）

（コマンド引数） がキーワードなら、それに関係するタスクだけに絞る。

## 2. 優先度を付ける

上から順に優先する。

1. **P1 壊れている**: 失敗中のテスト・ビルド、バグ、ほかのタスクを止めているもの
2. **P2 途中**: 着手済み・未コミット・未 push の作業
3. **P3 承認済みで未着手**: 依頼・承認済みのタスク
4. **P4 改善**: 品質向上・ドキュメント・機能拡張の候補
5. **保留**: ユーザー入力・承認待ち（別枠で表示する）

同じ優先度の中では、表の「目安」が短いものを先にする（10分 → 20分 → 1時間）。目安が同じときだけ、ファイルに書かれた順にする。表を出す前に、各優先度の中で目安が昇順になっているか確認する。

## 3. 表示する

前置きは書かない。次の形だけを出す。

```
最優先: <1件> — <理由> （目安 <時間>）

| # | 優先度 | タスク | 出どころ | 目安 |
|---|---|---|---|---|
| 1 | P1 | ... | `file:line` / commit / 会話 | 10分 |

保留: <タスク> — <待っているもの>
```

- 表に出すのは最大5件。残りがあれば「ほか N 件（`/priorities all` で全件）」と1行だけ添える。（コマンド引数） が `all` なら全件出す。
- 目安は「10分」「1時間」のように具体的な単位で書く。
- タスクが0件なら「未完了タスクなし」と1行だけ出す。

最後に1行: `次の一手: /pickup <最優先タスク> で着手`
