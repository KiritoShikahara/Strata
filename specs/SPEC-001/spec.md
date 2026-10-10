# 機能仕様: Hermes(Strata) オーケストレーター + Claude Code ultra ワーカー

**SPEC-ID**: SPEC-001
**作成日**: 2026-10-10
**状態**: 実装済み(Hermes 実機確認待ち)
**優先度**: P1

## 概要

Strata のローカルモデルで動く Hermes をオーケストレーター(分解・委譲・検証)とし、実装や調査を Claude Code の ultra プロファイル(ヘッドレス)へ委譲できるようにする。委譲の ON/OFF と、ワーカーが使う Claude アカウントを、Hermes の `/` コマンドでセッション中に切り替えられる。

## 背景(調査済みの事実)

- `..\ClaudeCode-Context\kit\worker.mjs` が ultra 構成(`system.<model>.md` / `mcp.local.json` / `settings.ultra.json`)を `claude -p` で1タスク実行し、最終回答だけを標準出力に返す。
- `worker.mjs` は `CLAUDE_CONFIG_DIR` を設定せず、呼び出し元の環境変数を引き継ぐ。アカウントは `CLAUDE_CONFIG_DIR=%USERPROFILE%\.claude-account<N>` で決まる。
- `claude-<N>-ultra.cmd` は対話 TUI を開き `pause` で止まるため、ワーカーとして直接は呼べない。
- Hermes v0.21.5 の `/` コマンド解決順は quick_commands → plugins → bundles → skills(`cli.py:1232`)。
- `quick_commands` の `type: exec` は LLM を介さずシェルを実行するが、引数(`user_args`)をコマンドへ渡さない。タイムアウトは 30 秒(`cli.py:1265-1276`)。
- quick command の出力は画面に出るだけで、モデルの文脈には入らない。
- `.credentials.json` があるのは `.claude-account1` のみ。`.claude-account2` / `.claude-account3` には無い(未ログインの可能性)。

## ユーザーストーリー

### US1: ワーカーへ委譲する(P1)
ワーカー ON のとき、Hermes に実装や調査を頼むと、Hermes がタスクを分解して Claude Code ultra ワーカーへ渡し、返ってきた結果を検証して報告する。

**受け入れ条件**
1. ON の状態で実装依頼を出すと、ワーカーが起動し、その最終回答が Hermes の文脈に入る。
2. ワーカーは ultra 構成で起動する(`--system-prompt-file` と `--mcp-config` が ultra のもの)。
3. ワーカーが失敗(終了コード 0 以外)したら、Hermes は原因を報告し、同じ方法を3回繰り返さない。

### US2: ワーカーの使用を切り替える(P1)
`/` コマンドでワーカーの ON/OFF を切り替える。OFF のときは現状どおりローカルモデルだけで作業する。

**受け入れ条件**
1. OFF のとき、委譲スクリプトは Claude を起動せず、無効である旨を出力して終了する(モデルが指示を無視しても Claude は動かない)。
2. 切り替えは Hermes を再起動せずに次の依頼から有効になる。
3. 状態は Hermes を終了しても保持される。
4. 状態確認コマンドで ON/OFF・アカウント・モデルが1行で表示される。

### US3: ワーカーのアカウントを切り替える(P2)
`/` コマンドでワーカーが使う Claude アカウント(1〜3)を切り替える。

**受け入れ条件**
1. 切り替え後のワーカーは、指定アカウントの `CLAUDE_CONFIG_DIR` で起動する。
2. 存在しない、または未ログインのアカウントを指定したら、切り替えずに理由を表示する。
3. アカウントを切り替えても ON/OFF 状態は変わらない。

### US4: ワーカーのモデルを切り替える(P2)
`/` コマンドでワーカーのモデル(opus / sonnet)を切り替える。既定は opus。

**受け入れ条件**
1. 状態ファイルが無い初回は opus の ultra 構成で起動する。
2. 切り替え後のワーカーは、指定モデルの `system.<model>.md` で起動する。

## 機能要件

- **FR-001**: 委譲は1つのラッパースクリプト経由とする。ラッパーは状態ファイルを読み、`CLAUDE_CONFIG_DIR` を設定して `worker.mjs` を呼ぶ。
- **FR-002**: 状態(enabled / account / model)は Hermes ホーム配下の1ファイルに保存する。
- **FR-003**: 切り替えコマンドは LLM を介さず決定的に動く。Hermes の `quick_commands`(`type: exec`)で、引数なしの `/worker-on` `/worker-off` `/worker-1` `/worker-2` `/worker-3` `/worker-opus` `/worker-sonnet` `/worker-status` を登録する。
- **FR-004**: OFF の強制はラッパー側で行う(プロンプト指示だけに頼らない)。
- **FR-005**: `hermes/kiridev-core.md` に委譲ルールを1行追加する。ルールは「実装・調査の前にラッパーを呼ぶ。無効と返ったら自分で作業する」とする。
- **FR-006**: ワーカーへ渡すプロンプトには、目的・対象パス・完了条件を含める(ワーカーは文脈ゼロで起動し、質問を返せない)。
- **FR-007**: ラッパーが ctx-kit の場所を自分で解決する(環境変数 `CTXKIT_ROOT`、無ければ `%USERPROFILE%\.claude-ctxkit\root.txt`)。ctx-kit が無い環境では、ラッパーが理由を出力して終了し、Hermes は従来どおり動く。`strata-hermes.bat` は変更しない。
- **FR-008**: ラッパーは skill の `scripts/` に置き、`scripts/sync-hermes-skills.ps1` が Hermes ホームへ配布し、同じスクリプトが quick_commands を登録する。
- **FR-010**: 既定値は enabled=false / account=1 / model=opus とする。状態は Hermes 終了後も保持し、次回起動時に引き継ぐ。
- **FR-011**: ON のとき、scope(FR-014)に含まれる作業をワーカーへ渡す。Hermes は分解・委譲・検証を行う。
- **FR-012**: アカウントの設定ディレクトリに `.credentials.json` が無い場合は未ログインとみなし、切り替えを拒否して理由を表示する。
- **FR-013**: ON のとき、Web 検索と Web ページの読み取りもワーカーへ渡す。ラッパーの `run --web` がワーカーに WebSearch / WebFetch を与える(既定では与えない)。ctx-kit の `worker.mjs` に `--tools` オプションが必要。
- **FR-014**: 委譲する範囲(scope)を `/worker-impl`(実装だけ)、`/worker-code`(実装とファイル調査)、`/worker-web`(Web 調査だけ)、`/worker-all`(すべて)で切り替えられる。既定は impl(調査と Web 検索は Strata 側の Hermes が行い、実装は Claude Code が行う)。範囲外の `run` はラッパーが終了コード 3 で拒否し、Claude を起動しない。作業の種類は `--web`(Web 調査)、`--readonly`(調査)、どちらも無し(実装)で判定する。
- **FR-009**: 自動テストは必須とする。ラッパーの ON/OFF 分岐、アカウント解決、未ログイン拒否を、Claude を実際に起動せず(`CTXKIT_ROOT` を偽の kit に差し替えて)検証する。

## 成功基準

- **SC-001**: ON にしてから「README に1行追記して」と頼むと、ワーカーが編集し、Hermes が差分を確認して報告する。
- **SC-002**: OFF にした直後の依頼で、`claude.exe` のプロセスが1つも起動しない。
- **SC-003**: アカウント切り替え後、ワーカーの stderr の統計行と状態確認コマンドが同じアカウントを示す。
- **SC-004**: FR-009 の自動テストがすべて通る。

## 範囲外

- Qwen Code(`strata-qwen.bat`)側からの委譲。
- ワーカーの並列実行。
- アカウントのログイン操作の自動化。

## 明確化(2026-10-10 回答済み)

1. コマンドの形 → quick_commands で引数なしの複数コマンド(FR-003)。
2. 起動時の状態 → 前回の状態を引き継ぐ(FR-010)。
3. ON のときの委譲範囲 → 実装と調査をすべて(FR-011)。
4. ワーカーのモデル → コマンドで切り替え可、既定は opus(US4、FR-010)。
5. account2 / account3 → 未ログインなら拒否、ログインはユーザーが行う(FR-012)。
