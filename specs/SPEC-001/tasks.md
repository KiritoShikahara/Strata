# タスク: SPEC-001 Hermes オーケストレーター + Claude Code ultra ワーカー

**計画**: [plan.md](plan.md)
**形式**: `- [ ] T番号 [P:並列可] [USn] 内容(ファイルパス)`。テストを先に書く(TDD)。

## フェーズ1: 土台

- [x] T001 skill のディレクトリと `SKILL.md` の frontmatter を作る(`skills/workflow/claude-worker/SKILL.md`)
- [x] T002 状態の読み書き(既定値、壊れたファイルの扱い)のテストを書く(`skills/workflow/claude-worker/scripts/claude-worker.test.mjs`)
- [x] T003 状態の読み書きと `status` を実装する(`skills/workflow/claude-worker/scripts/claude-worker.mjs`)

## フェーズ2: US2 ワーカーの ON/OFF(P1)

- [x] T004 [US2] `on` / `off` と、OFF 時の `run` が終了コード 3 で偽 `CLAUDE_EXE` を起動しないことのテストを書く(`skills/workflow/claude-worker/scripts/claude-worker.test.mjs`)
- [x] T005 [US2] `on` / `off` と `run` の無効時分岐を実装する(`skills/workflow/claude-worker/scripts/claude-worker.mjs`)

## フェーズ3: US1 委譲(P1)

- [x] T006 [US1] ON 時の `run` が `worker.mjs` を正しい引数で呼び、出力と終了コードを返すこと、ctx-kit 無しで終了コード 4 になることのテストを書く(`skills/workflow/claude-worker/scripts/claude-worker.test.mjs`)
- [x] T007 [US1] ctx-kit の解決と `run` の委譲を実装する(`skills/workflow/claude-worker/scripts/claude-worker.mjs`)
- [x] T008 [P] [US1] 委譲手順(プロンプトに目的・パス・完了条件を書く、失敗時の扱い)を書く(`skills/workflow/claude-worker/SKILL.md`)
- [x] T009 [P] [US1] 委譲ルールを1行追加する(`hermes/kiridev-core.md`)
- [x] T010 [P] [US1] `workflow/claude-worker` を追加する(`hermes/active-skills.txt`) → 変更不要(`workflow` カテゴリ全体が有効)

## フェーズ4: US3 アカウント切り替え(P2)

- [x] T011 [US3] `account` の正常系、範囲外、未ログイン拒否、`run` が `CLAUDE_CONFIG_DIR` を渡すことのテストを書く(`skills/workflow/claude-worker/scripts/claude-worker.test.mjs`)
- [x] T012 [US3] `account` と `CLAUDE_CONFIG_DIR` の設定を実装する(`skills/workflow/claude-worker/scripts/claude-worker.mjs`)

## フェーズ5: US4 モデル切り替え(P2)

- [x] T013 [US4] `model` の正常系、不正値、既定 opus、`run` が `--model` を渡すことのテストを書く(`skills/workflow/claude-worker/scripts/claude-worker.test.mjs`)
- [x] T014 [US4] `model` を実装する(`skills/workflow/claude-worker/scripts/claude-worker.mjs`)

## フェーズ6: 配布と確認

- [x] T015 quick_commands 8件の登録を追加する(`scripts/sync-hermes-skills.ps1`)
- [x] T016 [P] コマンド一覧を追記する(`README.md`)
- [x] T017 `node --test skills/workflow/claude-worker/scripts/claude-worker.test.mjs` を実行し、全件通ることを確認する
- [ ] T018 同期スクリプトを実行し、`plan.md` の手動確認4手順を実機で行う(SC-001〜SC-003) → 同期と、シェルからの ON/OFF・委譲・未ログイン拒否は確認済み。Hermes 画面内の手動確認4手順が未実施

## 依存関係

- T003 → T005 → T007 → T012 / T014(同じファイルなので直列)
- T008、T009、T010、T016 は他と並列可
- T015 は T014 の後
