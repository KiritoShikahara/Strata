# Strata セットアップ手順: この PC（RTX 5070 12GB / RAM 64GB）版

AI エージェントに渡して、この PC に Strata を導入させるための指示書。3070 8GB 版（Hermes 連携）の書式に合わせ、この PC で実測した値だけを書く。

導入するもの: https://github.com/Niko1221/Strata。手順は `docs/AI_SETUP.md` に従い、下記のこの PC 向けの決定事項で上書きする。

## 既知のハードウェア（再検出も変更もしない）
- GPU: NVIDIA GeForce RTX 5070 12 GB（ドライバ 581.57、導入済み。ドライバは絶対に更新しない）
- RAM: 64 GB（Strata の導入先ドライブ C: は空き 1.7 TB）
- サーバーは `127.0.0.1` にのみバインドし、API キーなしのローカル利用に限る（外部に公開しない）

## 決定事項（再質問しない）
- モデル: `qwen` ファミリー、IQ2_XS（`--family qwen --model IQ2_XS`）。理由: docs の 64GB 向け推奨で、品質と速度のバランスが良い。他に Q2_0（最速）、IQ3_XXS（高品質）、IQ3_S も 64GB に収まる
- コンテキスト: 131072（この GPU で実測。下記の「重要」参照）
- 導入先: `C:\Strata`、モデルデータは `C:\Strata-data`（約 72GB。既にあれば再利用し、再ダウンロードしない）
- API で使うモデル名: `strata`（サーバーは任意の名前を受け付ける）

## 重要: この GPU の VRAM 予算（12GB）
1. **GPU を専有させる**: 起動前に、GPU を多く使う他のアプリ（LM Studio、Ollama、ゲーム、ブラウザの GPU 処理）を閉じる。`nvidia-smi` で空き VRAM が 6GB 以上あることを確認してから起動する。起動時に空きが少ないと、エキスパートキャッシュが縮んで極端に遅くなる
2. **コンテキストは 131072 のまま使う**: setup が自動で KV ストリーミング（KV キャッシュを RAM に置く）と `--kv-resident 32768` を有効にする。この構成での実測は下表のとおり。無理に変えない
3. 起動に失敗して「the draft head does not fit」と出たら、`--draft-vocab en` を付けて再起動する

| 項目 | 実測値（2026-10-06、この PC） |
| --- | --- |
| エキスパートキャッシュ | 3834 スロット（5.15 GiB の VRAM、起動時の空き 5.98 GiB） |
| 生成速度 | 59〜79 tok/s（80K トークンの履歴があっても 64〜74 tok/s） |
| プロンプト読み込み | 約 1,100〜1,200 tok/s（6K トークンの新規）、再利用分は即時 |
| 起動時間 | 初回 1〜3 分（PC が重くなる）、2 回目以降は 30〜90 秒 |

## 手順
1. `docs/AI_SETUP.md` と `docs/TROUBLESHOOTING.md` を先に読む。`cmd /c "C:\Strata\START-HERE.bat" --check` で事前確認する（git-bash から実行するときはフルパスで呼ぶ。相対名だと「認識されない」と出る）
2. 非対話で導入する（`--no-start` で起動はしない）:
   `START-HERE.bat --yes --family qwen --model IQ2_XS --context 131072 --no-start`
   - ダウンロードは約 70GB（GGUF 2 ファイルと約 5GB の MTP ドラフト層）。途中で止めても続きから再開する
3. `strata-iq2_xs.json` に `"fit_max_tokens": true` を追加する。これが無いと、Qwen Code が `max_tokens` を大きく送ったときに 400 エラー（prompt + max_tokens がコンテキストを超える）になる。`START-HERE.bat` を再実行しても、この設定は保持される
4. `run-iq2_xs.bat` で起動する（専用の窓が開く）。`http://127.0.0.1:8080/health` を 10 秒ごとに確認し、最大 300 秒待つ。初回の読み込み中に PC が重くなるのは正常なので、止めない
5. 実際のリクエストで検証する（`/health` だけで済ませない）:
   - `GET /v1/models` がモデルを返し、`"loaded": true`、`max_context` が 131072 になっている
   - ストリーミングの chat completion が、`finish_reason` が `"stop"` のチャンクと `data: [DONE]` で終わる。冒頭の role チャンクの後で接続が切れたら、VRAM 不足なので「重要」の 1 に戻る
   - `C:\Strata\strata-iq2_xs.log` で、`expert cache ... slots` が数千であることと、生成速度が数十 tok/s であることを確認する。スロットが 1 桁、または 15 tok/s 未満なら、先に VRAM を空ける
6. Qwen Code に接続する（設定の置き場所は `~\.qwen\settings.json`）:
   - `npm install -g @qwen-code/qwen-code`
   - 環境変数: `OPENAI_BASE_URL=http://127.0.0.1:8080/v1`、`OPENAI_API_KEY`（任意の文字列）、`OPENAI_MODEL=strata`
   - `~\.qwen\settings.json` に `modelProviders.openai` で `id: "strata"`、`baseUrl`、`generationConfig.contextWindowSize: 120000`、`samplingParams.max_tokens: 8192` を設定する
   - 止まらない設定: `context.autoCompactThreshold: 0.7`、`model.maxSessionTurns: -1`、`model.sessionTokenLimit: -1`
   - 一括で行う場合は `install-strata-qwen.bat`（手順 1〜7 をまとめて実行。設定は `qwen-settings.js` が書く）
7. 起動は `strata-qwen.bat` を使う。Strata が起動していなければ起動し、応答を待って `qwen --approval-mode yolo` を開く。この bat が起動した場合のみ、終了時に Strata も止める
8. 結果を報告する: ログから実測の tok/s、エキスパートキャッシュのスロット数、各エンドポイント（OpenAI `http://127.0.0.1:8080/v1`、Anthropic `/v1/messages`、ブラウザ UI `:8080`）

## この PC で踏んだ落とし穴
- コンテキスト 32768 のままだと、Qwen Code のシステムプロンプトとツール定義（6〜13K トークン）で上限に達し、「prompt leaves no room to answer」で 400 になる
- `max_tokens` が 64000 のままだと、同様に 400 になる（`fit_max_tokens` で解消）
- Claude Code から bat を呼ぶと、相対名で「認識されない」と出る。フルパスで `call` する
- bat は CRLF・ASCII のみで保つ（LF や日本語が入ると cmd で壊れる。`.gitattributes` で固定済み）
- 複数の窓で `strata-qwen.bat` を使うと、先に開いた窓を閉じた時点で、後から開いた窓の Strata も止まる（未修正）
- 動作確認で `strata.exe` を強制終了すると、使用中のセッションも落ちる
