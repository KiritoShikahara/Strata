# 引き継ぎ (2026-10-06 14:32 / main)

次の一手: 別 PC で `install-strata-qwen.bat` をダブルクリックし、最後まで通るか確認する（約 70GB のダウンロードで数時間）。

## 完了
- 環境 B（5070 12GB / RAM 64GB）に Strata（IQ2_XS）と Qwen Code 0.25.0 を導入し、Qwen Code 経由の応答を確認した（約 75〜79 tok/s）
- `install-strata-qwen.bat`: Git・Node.js・Strata・モデル・Qwen Code を 1 クリックで導入する。再実行しても済んだ手順は飛ばす（fe09878）
- `strata-qwen.bat`: Strata を起動して Qwen Code を開く。起動中なら再利用し、自分で起動した場合だけ終了時に Strata を停止する。1 ファイルだけ他プロジェクトにコピーして使える（85b07c7）
- 400 エラー（max_tokens 64000 > 文脈 32768）を `fit_max_tokens: true` で解消した（インストーラーが自動で設定する）

## 残り（優先順・最大5件）
- 別 PC（環境 A・C）でインストーラーを新規実行して検証する。Git・Node の自動導入と初回導入は未確認
- `strata-qwen.bat` の窓を × で閉じたときに `strata.exe` が残らないかを確認する
- `README.md` の「Qwen Code の接続」を実値で更新する（URL `http://127.0.0.1:8080/v1`）
- Qwen Code でツール呼び出し（ファイル編集など）が動くか試し、opencode と成功率・初回応答秒数を比較する
- 不満があればモデルを変える（Q2_0 は速い、IQ3_XXS は品質寄り）

## 保留
- 無検閲版 OrcaRouter IQ3_XXS — 手動手順が必要（`C:\Strata\docs\ORCA.md`）。通常版で不満が出たら検討
- データの置き場所 — 現在は `C:\Strata-data`。リポジトリ内に移す場合は `--data-dir` で再実行し、先に `.gitignore` を直す

## 再開に必要なもの
- git に入らないもの: `C:\Strata`（インストーラーが clone する）、`C:\Strata-data`（約 70GB、空き約 80GB が必要）
- bat は CRLF・ASCII のみで保つ（LF や日本語が入ると cmd で壊れる）
- Claude Code 経由で bat を呼ぶときはフルパスを使う（相対名だと「認識されない」と出る）
- 環境変数（名前のみ）: `OPENAI_BASE_URL`、`OPENAI_API_KEY`、`OPENAI_MODEL`（`strata-qwen.bat` 内で設定済み）、`STRATA_DIR`（任意）
