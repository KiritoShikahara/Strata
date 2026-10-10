# Claude Code ワーカーの使い方

Hermes（Strata のローカルモデル）に依頼した作業を、Claude Code に任せるための機能です。Hermes が作業を分けて Claude Code に渡し、結果を確認してから報告します。

## 最初に 1 回だけ行うこと

1. ClaudeCode-Context（ctx-kit）の `install.bat` を実行する。
2. 使いたい Claude アカウントでログインする（`claude-1.cmd` など）。
3. このリポジトリで次を実行する（約 1 分）。

   ```
   powershell -File scripts\sync-hermes-skills.ps1
   ```

4. `strata-hermes.bat` で Hermes を起動する。すでに起動している場合は再起動する。

`scripts\sync-hermes-skills.ps1` は、このリポジトリを更新したあとにも実行してください。

## 基本の使い方

1. Hermes の入力欄に `/worker` と入力する。候補と説明の一覧が出る。
2. `/worker-on` を選んで Enter を押す。`worker: ON account=1 model=opus scope=impl` と表示される。
3. いつもどおり依頼する（例: 「README に 1 行追記して」）。実装は Claude Code が行う。
4. やめるときは `/worker-off` を実行する。

設定は Hermes を再起動しても残ります。

## コマンド一覧

すべて引数なしで、入力するとすぐに切り替わります（モデルは呼び出しません）。

| コマンド | 動作 |
| --- | --- |
| `/worker-on` | ワーカーを使う |
| `/worker-off` | ワーカーを使わない（初期値） |
| `/worker-status` | 現在の設定を表示する |
| `/worker-1` `/worker-2` `/worker-3` | 使う Claude アカウントを選ぶ（初期値は 1） |
| `/worker-opus` `/worker-sonnet` | ワーカーのモデルを選ぶ（初期値は opus） |
| `/worker-impl` | 実装だけを任せる（初期値。調査と Web 検索は Hermes が行う） |
| `/worker-code` | 実装とファイル調査を任せる |
| `/worker-web` | Web 検索だけを任せる |
| `/worker-all` | 実装、ファイル調査、Web 検索のすべてを任せる |

## 表示の読み方

`/worker-status` は次の 1 行を表示します。

```
worker: ON account=1 model=opus scope=impl
```

| 項目 | 意味 |
| --- | --- |
| `ON` / `OFF` | ワーカーを使うかどうか |
| `account` | 使う Claude アカウントの番号 |
| `model` | ワーカーのモデル |
| `scope` | 任せる範囲（`impl` / `code` / `web` / `all`） |

## うまくいかないとき

| 症状 | 原因と対処 |
| --- | --- |
| `/worker` と入力しても候補が出ない | `powershell -File scripts\sync-hermes-skills.ps1` を実行し、Hermes を再起動する。 |
| `account 2 is not logged in` と表示される | そのアカウントは未ログイン。`claude-2.cmd` でログインしてから、もう一度 `/worker-2` を実行する。 |
| `/worker-on` にしたのに Hermes が自分で作業する | 依頼が任せる範囲の外にある。`/worker-status` で `scope` を確認し、`/worker-code` や `/worker-all` に切り替える。ctx-kit が見つからない場合も Hermes が自分で作業するので、ctx-kit の `install.bat` を実行する。 |
| リポジトリのフォルダを移動したらコマンドが動かない | 新しい場所で `powershell -File scripts\sync-hermes-skills.ps1` を実行する。 |

## 関連ファイル

- 仕様: `specs/SPEC-001/spec.md`
- 設定の保存先: `%LOCALAPPDATA%\hermes\kiridev-worker.json`
- コマンドの登録先: `%LOCALAPPDATA%\hermes\plugins\kiridev-worker`
