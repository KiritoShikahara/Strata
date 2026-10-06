---
name: strata
description: Strata ローカル LLM サーバの起動・疎通・設定・トラブル対応
version: 1.0.0
metadata:
  hermes:
    tags: [kiridev, ai, strata, local-llm]
    category: ai
  kiridev:
    namespace: kiridev
    category: ai
    triggers: [Strata, ローカルモデル, 8080, IQ3_XXS, tok/s, モデルサーバ]
    required_tools: [terminal]
    optional_tools: [read_file]
    dependencies: [curl]
    conflicts: []
    workflow: see '## Procedure'
    verification: "curl http://127.0.0.1:8080/health が 200、hermes chat -q ... --provider strata -m strata --oneshot が応答"
    fallback: ["Strata 停止/未導入 → LM Studio（lms server start, port 1234）→ Hermes fallback_providers"]
    risk_level: medium
    source: hand-written
---

# strata

Strata = llama.cpp ベースの OpenAI 互換ローカル推論サーバ（Inference Backend 専用。Skill は Hermes 側に置く）。

## 既定値
- 本体 `D:\Strata`（`STRATA_DIR` で変更）、データ `D:\Strata-data`、モデル tag は `D:\Strata\selected-model.txt`（既定 `iq3_xxs`）
- 起動: `D:\Strata\run-<tag>.bat`、または KiriDev repo の `strata-hermes.bat`（起動 + Hermes を `--provider strata -m strata --yolo` で開く）
- API: `http://127.0.0.1:8080/v1`（health: `/health`）。Hermes provider 名 `strata`（config.yaml `providers.strata`、context 131072）

## Procedure
1. 状態: `curl -s -m 3 http://127.0.0.1:8080/health`、`Get-NetTCPConnection -LocalPort 8080 -State Listen`、`nvidia-smi`。
2. 未起動なら `run-<tag>.bat` を別ウィンドウで起動（`Start-Process cmd -ArgumentList '/c','D:\Strata\run-iq3_xxs.bat'`）し、health が 200 になるまで 5 秒間隔で待つ（初回 1〜3 分）。
3. 疎通: `hermes chat -q "reply OK" --provider strata -m strata --oneshot`。
4. 速度: benchmark Skill の LLM 手順（tok/s）。
5. 問題時: `D:\Strata\download.log`・サーバ出力を確認。VRAM 不足 → より小さい量子化 / GPU offload 層を減らす（gpu-offload Skill）。

## Prohibited
- インストール/ダウンロード中（`run-<tag>.bat` が未作成、download.log が進行中）のプロセスを停止・再実行しない。
- 2 つのセットアップを同時に動かさない（.part ファイル破損）。
