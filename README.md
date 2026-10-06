# Strata 作業メモ

[Niko1221/Strata](https://github.com/Niko1221/Strata)（Qwen3.8-Flash-Next を普通の PC で動かすエンジン）の導入作業を、別の PC で再開するためのメモ。

## 現在の構成（2026-10-03 時点）

| 項目 | 内容 |
| --- | --- |
| PC | RTX 4070 Ti 12GB / DDR5-6000 32GB / Ryzen 7 9800X3D |
| モデル | Qwen3.8-Flash-Next **Coder**（IQ1_M、ダウンロード 58GB、RAM 約 23GB） |
| 実験機能 | experimental speed projection（拒否を減らす）: **ON** |
| 本体の場所 | `C:\Strata`（Strata のクローン、エンジンは `C:\Strata\engine\strata.exe`） |
| モデルの場所 | `C:\Strata-data\models\coder-IQ1_M` |
| ログ | `C:\Strata\setup.log` |

32GB RAM では Coder しか載らない。64GB にすると IQ2_XS（推奨）など全サイズが使える（`docs/MODELS.md`）。

## 想定する 3 環境

| 環境 | GPU | RAM | 使えるモデル |
| --- | --- | --- | --- |
| A（現行） | RTX 4070 Ti 12GB | DDR5 32GB | Coder IQ1_M のみ |
| B | RTX 5070 12GB | DDR5 64GB | 全サイズ（IQ2_XS 推奨） |
| C | RTX 3060 12GB | DDR4 64GB | 全サイズ（DDR4 のため B より遅い見込み） |

サイズ別の必要 RAM は `docs/MODELS.md` を参照（未確認）。

## 別の PC で再開する手順

1. 本体をクローン: `git clone https://github.com/Niko1221/Strata C:\Strata`
2. セットアップ（約 58GB ダウンロード、6MB/s で約 3 時間）:
   ```
   cd C:\Strata
   .\START-HERE.bat --setup --family coder --yes --no-start --experimental-speed-projection on
   ```
3. 起動: `C:\Strata\START-HERE.bat`（2 回目以降は起動だけ行う）
4. 短い質問を 1 つ送って tok/s を確認（4070 Ti の予想: 45〜55 tok/s）

### モデルをコピーして時間を短縮する

元の PC の `C:\Strata-data\models\coder-IQ1_M` の 2 ファイルを新しい PC の同じ場所に置けば、手順 2 のダウンロードが省ける（`--gguf-dir <フォルダ>` でも指定可）。

## 注意

- セットアップは 1 つだけ動かす。2 つ同時に動かすと同じ `.part` ファイルに書き込んで壊れる。
- ダウンロードが途中で止まっても、同じコマンドを再実行すれば `.part` から続きを取得する。
- speed projection は安全のための拒否を外す機能。Web 画面の Sampling からチャットごとにオフにできる。

## 目的と方針

- 目的: Strata で Qwen3.8-Flash-Next を動かす環境を作る。
- 利用ハーネス: **Qwen Code**（第一候補）。Qwen のツール呼び出し形式に合わせて作られているため。比較対象は opencode。
- 複数環境（上の A / B / C）で動かすため、**全モデルを動かす可能性がある**。モデル名や設定は環境ごとに差し替えられる形にする。
- 優先順位: 安定性 > 速度 > 軽さ。ハーネスの完成度（賢く使えること）も重視する。

## Qwen Code の接続

`strata-qwen.bat` が次の値を設定して Qwen Code を起動する（環境 B で確認済み）。

- `OPENAI_BASE_URL=http://127.0.0.1:8080/v1`（ヘルスチェック: `http://127.0.0.1:8080/health`）
- `OPENAI_API_KEY=strata`
- `OPENAI_MODEL=strata`（固定。実際のモデルは `C:\Strata\selected-model.txt` で切り替える）

未確認:

1. 同じ課題を opencode でも試し、ツール呼び出し成功率と初回応答秒数を比較する
