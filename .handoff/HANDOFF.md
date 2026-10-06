# 引き継ぎ (2026-10-06 13:58 / main)

次の一手: 環境 B で `C:\Strata\run-iq2_xs.bat` ができているか確認する。無ければ `C:\Strata\START-HERE.bat --yes --family qwen --model IQ2_XS --no-start` を再実行する（ダウンロードは続きから再開する）。

## 完了
- `README.md` に 3 環境の表と目的・方針を追加（e97f1e8）
- 環境 B（5070 12GB / RAM 64GB）に `C:\Strata` を clone した
- Qwen Code 0.25.0 を `npm install -g @qwen-code/qwen-code` で導入した
- モデルは IQ2_XS（`--family qwen`）に決定。不満があれば Q2_0（速い）か IQ3_XXS（品質寄り）に変える。無検閲版 OrcaRouter IQ3_XXS は `docs/ORCA.md` の手動手順が必要なので後回し
- IQ2_XS のダウンロード: 1つ目 39.23GB は完了、2つ目 28.80GB は 94% で停止中に確認。データは `C:\Strata-data`

## 残り（優先順・最大5件）
- セットアップ完了を確認し、起動用 bat を作る（`run-iq2_xs.bat` を元にする）
- 起動後に `http://127.0.0.1:8080/v1/models` で応答を確認する
- Qwen Code を接続する: `OPENAI_BASE_URL=http://127.0.0.1:8080/v1`、`OPENAI_MODEL=strata`、API キーは任意の値
- `README.md` の「Qwen Code の接続」を実値で更新する
- 同じ課題を opencode でも試し、ツール呼び出し成功率と初回応答秒数を比較する。環境 A・C でもセットアップして tok/s を測る

## 保留
- Qwen3.8-Flash-Next での Qwen Code 動作 — 未検証
- モデルの起動直後は PC が 1〜3 分重くなる（docs/AI_SETUP.md）

## 再開に必要なもの
- Claude Code 経由の bat 実行では、`cmd /c START-HERE.bat` が「認識されない」と出る。フルパス `C:\Strata\START-HERE.bat` で `call` する
- 他の PC は `git clone https://github.com/Niko1221/Strata C:\Strata` から始める（モデルは約 70GB）
