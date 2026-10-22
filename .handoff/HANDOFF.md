# 引き継ぎ (2026-10-22 12:14 / main)

次の一手: 環境 C（RTX 3060 / 64GB）の PC を再起動し、`strata-hermes.bat` で Gyro-M が `ready` 後も落ちないか確認する

## 完了
- Hermes から Gyro-M が起動しない原因を特定: `ready` の直後にエンジンが終了。`D:\Strata\strata-gyro-gyro-m.log` 末尾の警告は「Windows commit limit 70.3 GiB, 3.3 GiB left」（Windows のメモリ上限の残りが 3.3GiB）で、上限に達すると何も表示せず 0xC0000409 で落ちる
- ページファイルを `C:\pagefile.sys` 32768〜65536 MB に変更し、自動管理をオフにした（再起動後に有効、まだ再起動していない）
- IQ2_XS は現行エンジン 0.1.47 で約40秒で `ready` になることを確認（今朝の失敗は Ctrl+C で止めたため）
- `strata-update.bat` を追加（9b38378）

## 残り（優先順・最大5件）
- 再起動後、`strata-hermes.bat` で Gyro-M を起動して確認する。まだ落ちる場合は `strata-gyro-gyro-m.log` 末尾の commit limit 警告を見る
- VRAM の空きが 344MiB しかない警告が出ている。落ちる場合は `--prefill auto:8192` か `--vram-reserve-mib` を増やす

## 再開に必要なもの
- Strata 本体 `D:\Strata`、モデル `D:\Strata-data`（git 外）、環境変数 `STRATA_DIR`
- 他の PC でも Gyro-M を使うなら、ページファイルを 32GB 以上にする
