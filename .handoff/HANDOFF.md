# 引き継ぎ (2026-10-06 12:12 / main)

次の一手: `C:\Strata\START-HERE.bat` を起動し、表示される URL とポートを控える。

## 完了
- `README.md` に 3 環境の表（A: 4070 Ti/DDR5 32GB、B: 5070/DDR5 64GB、C: 3060 12GB/DDR4 64GB）を追加
- `README.md` に目的と方針（Qwen Code を第一候補、opencode を比較対象、全モデルを動かす可能性）を追加（e97f1e8）

## 残り（優先順・最大5件）
- Strata の URL・ポートを確認し、`README.md` の「Qwen Code の接続」を実値で埋める
- `C:\Strata\docs\MODELS.md` を読み、環境別の推奨モデルと必要 RAM を `README.md` に反映する
- Qwen Code を Strata に接続し、同じ課題を opencode でも試して、ツール呼び出し成功率と初回応答秒数を比較する
- 環境 B・C でセットアップし、tok/s を測る（A の予想は 45〜55 tok/s）

## 保留
- モデルごとの必要 RAM — `docs/MODELS.md` の確認待ち（この PC では `C:\Strata` を読めなかった）
- Qwen Code の相性 — Qwen3.8-Flash-Next での動作は未検証（Qwen3-Coder 系からの推測）

## 再開に必要なもの
- `git clone https://github.com/Niko1221/Strata C:\Strata`
- セットアップ手順とモデルのコピー方法は `README.md` を参照
- Qwen Code（未導入なら導入が必要）。環境変数 `OPENAI_BASE_URL` / `OPENAI_MODEL` を設定する（値は Strata 起動後に確認）
