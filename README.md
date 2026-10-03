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
