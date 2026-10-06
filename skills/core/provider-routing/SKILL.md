---
name: provider-routing
description: Hermes の provider/fallback 設定を確認・追加・修復する
version: 1.0.0
metadata:
  hermes:
    tags: [kiridev, core, provider]
    category: core
  kiridev:
    namespace: kiridev
    category: core
    triggers: [provider 追加, API 接続エラー, fallback 設定, 新しいモデルサーバ]
    required_tools: [terminal, read_file, patch]
    optional_tools: []
    dependencies: [hermes, curl]
    conflicts: []
    workflow: see '## Procedure'
    verification: "hermes chat -q 'ping' --provider <p> -m <m> --oneshot が応答する"
    fallback: [設定を backup から復元, hermes fallback add で対話追加]
    risk_level: medium
    source: hand-written
---

# provider-routing

## Procedure
1. 現状確認: `hermes config path`、`hermes fallback list`、`hermes auth list`（値は表示しない）、
   ローカル: `curl -s http://127.0.0.1:8080/health`（Strata）、`curl -s http://127.0.0.1:1234/v1/models`（LM Studio, `lms server start`）。
2. 変更前に `config.yaml` を `config.yaml.bak.<日時>` にコピー。
3. OpenAI 互換サーバは `providers.<name>: {api, api_key, default_model, context_length, transport: chat_completions}` で追加。
4. 自動 fallback は top-level `fallback_providers:`（provider と model 必須、custom は base_url）。順序 = Local → Local 予備 → Cloud。
5. 疎通: `hermes chat -q "reply OK" --provider <p> -m <m> --oneshot`。

## Prohibited
- API key を repo や config の平文に追加しない（`~/.hermes/.env` か `hermes auth add`。ユーザーが行う）。
- `model.default` / `model.provider` をユーザー指示なしに変更しない。
