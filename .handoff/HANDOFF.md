# 引き継ぎ (2026-10-06 14:22 / main)

次の一手: `strata-qwen.bat` をダブルクリックし、Strata の起動と Qwen Code の起動を確認する（初回の読み込みは 1〜3 分、PC が重くなる）。

## 完了
- 環境 B（5070 12GB / RAM 64GB）に Strata を導入した: `C:\Strata`、データは `C:\Strata-data`、モデルは IQ2_XS（`--family qwen`）
- Qwen Code 0.25.0 を導入し、Strata 経由の応答を確認した（`qwen -p "1+1は？"` → 2、40秒）
- 起動用 bat を作成した: `strata-qwen.bat`（Strata を起動し、`/health` を待って `qwen` を開く）
- 400 エラー（max_tokens 64000 > 文脈 32768）を、`C:\Strata\strata-iq2_xs.json` に `"fit_max_tokens": true` を追加して解消した

## 残り（優先順・最大5件）
- `README.md` の「Qwen Code の接続」を実値で更新する（URL `http://127.0.0.1:8080/v1`、`OPENAI_API_KEY` は任意の値）
- Qwen Code で実際のツール呼び出し（ファイル編集など）が動くか試す
- 同じ課題を opencode でも試し、ツール呼び出し成功率と初回応答秒数を比較する
- tok/s を測る（docs の実測は IQ2_XS で 79 tok/s）
- 不満があればモデルを変える（Q2_0 は速い、IQ3_XXS は品質寄り）

## 保留
- 無検閲版 OrcaRouter IQ3_XXS — 手動手順が必要（`C:\Strata\docs\ORCA.md`）。通常版で不満が出たら検討
- データの置き場所 — いまは `C:\Strata-data` のまま。移す場合は `--data-dir` で再実行し、`.gitignore` を先に直す

## 再開に必要なもの
- git に入らないもの: `C:\Strata`（`git clone https://github.com/Niko1221/Strata C:\Strata`）、`C:\Strata-data`（約 70GB）、`strata-iq2_xs.json` の `fit_max_tokens` 設定
- 他の PC では `START-HERE.bat --yes --family qwen --model <サイズ> --no-start` を実行する。Claude Code 経由で bat を呼ぶときはフルパスで `call` する（相対名だと「認識されない」と出る）
- `npm install -g @qwen-code/qwen-code`
- 環境変数（名前のみ）: `OPENAI_BASE_URL`、`OPENAI_API_KEY`、`OPENAI_MODEL`（`strata-qwen.bat` 内で設定済み）
