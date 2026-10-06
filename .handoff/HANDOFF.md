# 引き継ぎ (2026-10-06 15:03 / main)

次の一手: 別 PC に `install-strata-qwen.bat` だけをコピーしてダブルクリックし、モデルを選んで最後まで通るか確認する（約 70GB のダウンロードで数時間）。

## 完了
- 環境 B（5070 12GB / RAM 64GB）に Strata（IQ2_XS）と Qwen Code 0.25.0 を導入し、応答を確認した（約 75〜79 tok/s）
- `install-strata-qwen.bat`（1 ファイルで完結、全 7 手順、再実行しても済んだ手順は飛ばす）。引数 `install-strata-qwen.bat 2` でモデルを指定できる
  - モデルを番号で選ぶ: 1 IQ2_XS（推奨）/ 2 Q2_0 / 3 IQ3_XXS / 4 IQ3_S / 5 Coder / 6 Swift
  - 同じフォルダに `strata-download.bat`（後からモデル追加・切替）と `strata-qwen.bat`（起動用）を書き出す
  - スキル 15 件を `~/.qwen/skills` に展開し、`qwen-settings.js` で Qwen Code の設定を書く
- `strata-download.bat`: 選んだモデルを `C:\Strata\selected-model.txt` に保存し、`strata-qwen.bat` がそれを起動する。API のモデル名は `strata` 固定
- `strata-qwen.bat`: Strata を起動して Qwen Code を YOLO モード（`--approval-mode yolo`、全ツール自動承認）で開く。起動済みなら再利用し、自分で起動した場合だけ終了時に停止する。単体で他プロジェクトにコピーできる
- 止まらない設定（`qwen-settings.js`）: 自動圧縮 70%、ターン数・トークン数の上限なし、ウィンドウ 120000、タイムアウト 15 分
- 文脈を 32768 → 131072 に拡大し、`fit_max_tokens: true` を設定した
- `.gitattributes` で `*.bat` と `*.cmd` を CRLF に固定した
- 検証済み: 引数 1〜6 の対応、インストーラー単体での展開（スキル 15 件・設定）、`strata-qwen.bat` の起動から停止まで（`aed5b6f`）

## 残り（優先順・最大5件）
- 別 PC（環境 A・C）で新規インストールを検証する。メニューの対話操作（`choice`）と、Git・Node の自動導入は未確認
- 自動圧縮が実際に働くか、長い作業で確認する
- `strata-qwen.bat` の窓を × で閉じたときに `strata.exe` が残らないか確認する
- Qwen Code でスキルとツール呼び出しが動くか試し、opencode と成功率・初回応答秒数を比較する
- `README.md` の「Qwen Code の接続」を実値で更新する（URL `http://127.0.0.1:8080/v1`）

## 保留
- 無検閲版 OrcaRouter IQ3_XXS — 手動手順が必要（`C:\Strata\docs\ORCA.md`）。通常版で不満が出たら検討
- データの置き場所 — 現在は `C:\Strata-data`。リポジトリ内に移す場合は `--data-dir` で再実行し、先に `.gitignore` を直す
- `handoff-sonnet` スキル — Sonnet のコンソール起動が前提で、Qwen Code では動かない可能性がある

## 再開に必要なもの
- git に入らないもの: `C:\Strata`（インストーラーが clone する）、`C:\Strata-data`（約 70GB、空き約 80GB が必要）、`C:\Strata\selected-model.txt`
- bat は CRLF・ASCII のみで保つ（LF や日本語が入ると cmd で壊れる）。Claude Code 経由で bat を呼ぶときはフルパスを使う
- `strata-qwen.bat`・`strata-download.bat`・`qwen-settings.js`・`qwen-skills/` を変更したら `node build-installer.js` を実行する（インストーラー末尾の埋め込みを再生成する）
- 環境変数（名前のみ）: `OPENAI_BASE_URL`、`OPENAI_API_KEY`、`OPENAI_MODEL`（`strata-qwen.bat` 内で設定済み）、`STRATA_DIR`（任意）
- 注意: IQ2_XS はツール呼び出しの精度が未検証で、YOLO モードと組み合わせると誤操作の恐れがある
