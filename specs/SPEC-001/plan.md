# 実装計画: SPEC-001 Hermes オーケストレーター + Claude Code ultra ワーカー

**仕様**: [spec.md](spec.md)
**備考**: このリポジトリには `.specify/`(テンプレートと constitution)が無い。research / data-model / contracts / quickstart はこのファイルにまとめる。

## 技術方針

- **言語**: Node.js(ESM、依存なし)。`worker.mjs` が Node 必須なので追加の導入物が無い。
- **テスト**: `node --test`(Node 標準)。Claude は起動せず、環境変数 `CTXKIT_ROOT` を偽の kit(呼び出され方を記録する `worker.mjs`)に差し替える。
- **配布**: 既存の skill 同期の仕組みに乗せる。`skills/workflow/verify/scripts/verify.ps1` と同じ置き方。

## 構成

| ファイル | 種別 | 役割 |
|---|---|---|
| `skills/workflow/claude-worker/scripts/claude-worker.mjs` | 新規 | ラッパー本体(状態の読み書き、委譲) |
| `skills/workflow/claude-worker/scripts/claude-worker.test.mjs` | 新規 | 自動テスト |
| `skills/workflow/claude-worker/SKILL.md` | 新規 | 委譲手順(プロンプトに書く内容、失敗時の扱い) |
| `hermes/kiridev-core.md` | 変更 | 委譲ルールを1行追加 |
| `scripts/sync-hermes-skills.ps1` | 変更 | ラッパーの `register` を呼び、quick_commands 8件を `hermes config set` で登録 |
| `README.md` | 変更 | コマンド一覧を追記 |

`strata-hermes.bat` と `build-installer.js` は変更しない。`hermes/active-skills.txt` は `workflow` カテゴリ全体が有効なので変更不要。

## データモデル

状態ファイル: `<HermesHome>\kiridev-worker.json`(`HERMES_HOME`、無ければ `%LOCALAPPDATA%\hermes`)

```json
{ "enabled": false, "account": 1, "model": "opus", "scope": "impl" }
```

- ファイルが無い、または壊れている場合は上の既定値を使う。
- `account`: 1〜3。設定ディレクトリは `%USERPROFILE%\.claude-account<N>`。
- `model`: `opus` または `sonnet`。
- `scope`: `impl`(既定) / `code` / `web` / `all`。`run` の `--web` は Web 調査、`--readonly` は調査、どちらも無ければ実装として判定し、範囲外は終了コード 3。

## コマンド契約

`node claude-worker.mjs <サブコマンド>`

| サブコマンド | 動作 | 終了コード |
|---|---|---|
| `on` / `off` | enabled を書き換え、状態を1行表示 | 0 |
| `account <1-3>` | 設定ディレクトリと `.credentials.json` を確認して書き換え | 0。範囲外・未ログインは 2(状態は変えない) |
| `model <opus\|sonnet>` | model を書き換え | 0。不正値は 2 |
| `status` | `worker: ON account=1 model=opus` の形で1行表示 | 0 |
| `run [--readonly] [--cwd DIR] "<task>"` | 下の「run の流れ」 | worker.mjs の終了コード。無効時は 3、ctx-kit 無しは 4 |

**run の流れ**
1. 状態を読む。`enabled=false` なら `WORKER_DISABLED: do this task yourself.` を出力して 3 で終了する。
2. ctx-kit の場所を解決する(`CTXKIT_ROOT`、無ければ `%USERPROFILE%\.claude-ctxkit\root.txt`)。`kit\worker.mjs` が無ければ 4 で終了する。
3. `CLAUDE_CONFIG_DIR` を指定アカウントに設定し、`node <kit>\worker.mjs --model <model> [--readonly] [--cwd DIR] "<task>"` を実行する。標準出力・標準エラー・終了コードをそのまま返す。

**quick_commands**(`config.yaml`、すべて `type: exec`)

| コマンド | 実行内容 |
|---|---|
| `/worker-on` `/worker-off` `/worker-status` | `on` / `off` / `status` |
| `/worker-1` `/worker-2` `/worker-3` | `account 1` / `account 2` / `account 3` |
| `/worker-opus` `/worker-sonnet` | `model opus` / `model sonnet` |
| `/worker-impl` `/worker-code` `/worker-web` `/worker-all` | `scope impl` / `scope code` / `scope web` / `scope all` |

## 調査結果と判断

- **quick command は引数を渡さない**(`cli.py:1265`)。そのため引数なしのコマンドを8件登録する。
- **quick command の出力はモデルの文脈に入らない。** モデルは ON/OFF を知らないので、core ルールは「実装・調査の前に必ず `run` を呼ぶ。`WORKER_DISABLED` が返ったら自分で作業する」とする。OFF 時は1依頼につきツール呼び出しが1回余分に発生する。
- **opus のとき `worker.mjs` は effort を `low` にする**(`worker.mjs:21`)。既定の opus はこの設定で動く。
- **未ログイン判定は `.credentials.json` の有無で行う。** Windows でこのファイルに資格情報が保存される前提に依存する(account1 にのみ存在することは確認済み)。

## リスク

- ローカルモデルが core ルールを守らず、ワーカーを呼ばずに自分で作業する可能性がある。OFF の強制はラッパーで保証できるが、ON の強制はプロンプト頼みになる。SC-001 の実機確認で判断する。
- `hermes config set quick_commands.worker-on.type exec` で入れ子キーが作れることは、一時的な `HERMES_HOME` で確認済み。

## 手動確認(quickstart)

1. `powershell -File scripts\sync-hermes-skills.ps1`
2. `strata-hermes.bat` を起動し、`/worker-status` で `worker: OFF account=1 model=opus` を確認する。
3. `/worker-on` の後に「README に1行追記して」と依頼し、ワーカーの統計行と差分を確認する。
4. `/worker-off` の後に同じ依頼を出し、`claude.exe` が起動しないことをタスクマネージャーで確認する。
