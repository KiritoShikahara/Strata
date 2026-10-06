# 引き継ぎ (2026-10-06 14:52 / main)

次の一手: 別 PC に `install-strata-qwen.bat` だけをコピーしてダブルクリックし、最後まで通るか確認する（約 70GB のダウンロードで数時間）。

## 完了
- 環境 B（5070 12GB / RAM 64GB）に Strata（IQ2_XS）と Qwen Code 0.25.0 を導入し、Qwen Code 経由の応答を確認した（約 75〜79 tok/s）
- `install-strata-qwen.bat`: Git・Node.js・Strata・モデル・Qwen Code を 1 クリックで導入し、手順 6 で `strata-qwen.bat` も書き出す。再実行しても済んだ手順は飛ばす
- `strata-qwen.bat`: Strata を起動して Qwen Code を開く。起動中なら再利用し、自分で起動した場合だけ終了時に Strata を停止する。1 ファイルだけ他プロジェクトにコピーして使える
- Qwen Code は YOLO モード（`--approval-mode yolo`、全ツールを自動承認）で起動する（2cce346）
- 文脈を 32768 → 131072 に拡大した（32K だと Qwen Code のプロンプトで上限エラーになる）。インストーラーは `--context 131072` で導入する（81de485）
- `fit_max_tokens: true` をインストーラーが `strata-iq2_xs.json` に設定する
- `qwen-skills/` に Qwen Code 用スキル 15 件を追加し、この PC の `~/.qwen/skills` に入れて認識を確認した（8e9df51）
- `.gitattributes` で `*.bat` と `*.cmd` を CRLF に固定した（a59999c）

## 残り（優先順・最大5件）
- インストーラーに `qwen-skills/*` を `~/.qwen/skills/` へコピーする手順を足す（現在は手動コピー）
- 別 PC（環境 A・C）でインストーラーを新規実行して検証する。Git・Node の自動導入と初回導入は未確認
- `strata-qwen.bat` の窓を × で閉じたときに `strata.exe` が残らないかを確認する
- Qwen Code でスキルとツール呼び出し（ファイル編集など）が実際に動くか試し、opencode と成功率・初回応答秒数を比較する
- README.md の「Qwen Code の接続」を実値で更新する（URL `http://127.0.0.1:8080/v1`）

## 保留
- 無検閲版 OrcaRouter IQ3_XXS — 手動手順が必要（`C:\Strata\docs\ORCA.md`）。通常版で不満が出たら検討
- データの置き場所 — 現在は `C:\Strata-data`。リポジトリ内に移す場合は `--data-dir` で再実行し、先に `.gitignore` を直す
- `handoff-sonnet` スキル — Sonnet のコンソール起動が前提で、Qwen Code では動かない可能性がある

## 再開に必要なもの
- git に入らないもの: `C:\Strata`（インストーラーが clone する）、`C:\Strata-data`（約 70GB、空き約 80GB が必要）
- bat は CRLF・ASCII のみで保つ（LF や日本語が入ると cmd で壊れる）。Claude Code 経由で bat を呼ぶときはフルパスを使う
- `strata-qwen.bat` を変更したら、`install-strata-qwen.bat` 末尾の埋め込み部分（`::| ` で始まる行）も同じ内容に更新する
- 環境変数（名前のみ）: `OPENAI_BASE_URL`、`OPENAI_API_KEY`、`OPENAI_MODEL`（`strata-qwen.bat` 内で設定済み）、`STRATA_DIR`（任意）
- 注意: IQ2_XS はツール呼び出しの精度が未検証で、YOLO モードと組み合わせると誤操作の恐れがある
