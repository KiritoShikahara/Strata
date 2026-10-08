# 引き継ぎ (2026-10-09 01:21 / main)

次の一手: `strata-qwen.bat` を実行し、既存の 8080 サーバーが停止→再起動され、`%STRATA_DIR%\strata-<TAG>-console.log` にログが出るか確認する。

## 完了
- `strata-qwen.bat` / `strata-hermes.bat`: 8080 で動作中の Strata を再利用せず停止→新規起動に変更。サーバー出力をコンソールログへリダイレクト（このコミット）
- 直近: experimental-speed-projection 既定有効化 (cee4492)

## 残り（優先順・最大5件）
- 上記 2 つの bat の実機動作確認（停止待ちループ、ログ出力、終了時の停止）
- README のコメント・説明が「再利用」前提なら更新

## 再開に必要なもの
- 環境変数 `STRATA_DIR`（未設定なら C:\Strata）とモデル（`strata-download.bat` で取得、GGUF は git 外）
