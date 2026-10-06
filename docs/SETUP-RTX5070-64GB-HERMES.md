# Strata セットアップ手順（Hermes 連携）: この PC（RTX 5070 12GB / RAM 64GB）版

`docs/SETUP-RTX5070-64GB.md` の Qwen Code 版に対する、Hermes 連携版。Strata の導入とモデルは同じで、違うのは手順 6 以降（Hermes への接続）だけ。

**未検証あり**: この PC には Hermes が入っておらず、Hermes 側の手順は実機で確認していない。根拠は、RTX 3070 8GB の PC で成功した手順（2026-10-06）と、この PC の実測値である。確認できていない箇所には「未検証」と書く。

## 前提（Qwen Code 版と同じ）
- GPU: NVIDIA RTX 5070 12 GB（ドライバ 581.57、更新しない）、RAM 64 GB
- サーバーは `127.0.0.1` のみ、API キーなしのローカル利用
- モデル: `qwen` ファミリー、IQ2_XS。コンテキスト: 131072。導入先: `C:\Strata`、データ: `C:\Strata-data`
- 起動前に GPU を多く使う他のアプリを閉じ、`nvidia-smi` で空き VRAM が 6GB 以上あることを確認する

## 3070 8GB 版との違い（この PC では変わる点）
| 項目 | 3070 8GB の PC | この PC（5070 12GB） |
| --- | --- | --- |
| モデル | coder IQ1_M | qwen IQ2_XS |
| コンテキスト | 40960（VRAM の都合で固定） | 131072 |
| Hermes の最低コンテキスト検査（64,000） | 40960 は不足。`lmstudio` プロバイダー経由で回避 | 131072 は検査を満たす。`custom` プロバイダーで通る見込み（**未検証**） |
| `max_tokens` | 16384 に制限 | 同じ設定で足りる（`fit_max_tokens` も有効） |

## 手順（導入までは Qwen Code 版の手順 1〜5 と同じ）
1. `START-HERE.bat --yes --family qwen --model IQ2_XS --context 131072 --no-start` で導入し、`strata-iq2_xs.json` に `"fit_max_tokens": true` を追加する
2. `run-iq2_xs.bat` で起動し、`http://127.0.0.1:8080/health` と `GET /v1/models`（`loaded: true`、`max_context: 131072`）を確認する
3. ストリーミングの chat completion が `finish_reason: "stop"` と `data: [DONE]` で終わることを確認する（Qwen Code 版の手順 5 と同じ）
4. Hermes に接続する（設定の置き場所は `C:\Users\<ユーザー名>\AppData\Local\hermes`）。次のいずれかを使う:
   - **A. `custom` プロバイダー（先に試す、未検証）**: コンテキストが 64K を超えるので、検査には通る見込み。エンドポイントは `http://127.0.0.1:8080/v1`、API キーは任意の文字列、モデル名は `strata`
   - **B. `lmstudio` プロバイダー（A が検査で弾かれたときの回避策）**: `.env` に `LM_BASE_URL=http://127.0.0.1:8080/v1` を書き、`LM_API_KEY` は任意の文字列にする。3070 の PC で実際に通った方法
5. 共通の設定:
   - `hermes config set model.context_length 131072`
   - `hermes config set model.max_tokens 16384`（未設定だと、Hermes が大きな `max_tokens` を送る恐れがある。`fit_max_tokens` が効けば 400 は避けられるが、明示しておく）
   - 補助モデル（圧縮・タイトル生成）は **Strata に向けない**。補助モデルは本体のコンテキストを引き継ぎ、同じ検査に失敗する恐れがある。3070 の PC では `zai` プロバイダーの `glm-5.3-flash` を使っていた:
     - `hermes config set auxiliary.compression.provider zai`
     - `hermes config set auxiliary.compression.model glm-5.3-flash`
     - `hermes config set auxiliary.title.provider zai`
     - `hermes config set auxiliary.title.model glm-5.3-flash`
   - プロバイダーのタイムアウト上書きは追加しない（Hermes がローカルのエンドポイントを自動検出し、ストリームの待機上限を 900 秒に上げる）
6. 動作確認（3070 の PC で通った形）:
   `hermes chat -q "Reply with exactly: STRATA-OK" --provider lmstudio -m strata`
   - `custom` を使う場合は、`--provider` を `custom` に変える（未検証）。返答が `STRATA-OK` と一致すれば成功
7. 報告する: ログの実測 tok/s、エキスパートキャッシュのスロット数、各エンドポイント（OpenAI `http://127.0.0.1:8080/v1`、Anthropic `/v1/messages`、ブラウザ UI `:8080`）

## 注意
- `hermes` のコマンドと設定キーは、3070 の PC での手順をそのまま写している。Hermes のバージョンが違うと、キー名が変わっている可能性がある
- モデル名は `strata` で通る想定（サーバーは任意の名前を受け付ける）。3070 の PC では実名 `qwen3.8-flash-next-coder-iq1_m` を使っていたので、弾かれたらこちらを試す
- Qwen Code と Hermes を同じ Strata に同時に向けても、Strata は一度に 1 リクエストしか処理しない
