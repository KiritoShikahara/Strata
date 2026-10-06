---
name: local-llm
description: ローカル LLM サーバー(Strata/LM Studio)の起動と接続確認
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - ai
    category: ai
  kiridev:
    namespace: kiridev
    category: ai
    triggers:
    - ローカルLLM
    - Strata
    - LM Studio
    - 8080
    - 1234
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - patch
    dependencies:
    - curl.exe
    conflicts: []
    workflow: see '## Procedure'
    verification: /v1/models が 200 で、chat/completions が内容を返す
    fallback:
    - Strata 不調なら LM Studio(:1234)へ base_url を切替
    - ポート競合は Get-Process -Id (Get-NetTCPConnection -LocalPort 8080).OwningProcess で確認
    - いずれも不可なら llama-cpp skill で llama-server を直接起動
    risk_level: medium
    related:
    - llama-cpp
    - model-selection
    - doctor
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# local-llm

ローカル LLM サーバー(Strata/LM Studio)の起動と接続確認

## When to Use
Trigger: ローカルLLM, Strata, LM Studio, 8080, 1234

## Tools
- required: terminal, read_file
- optional: patch
- dependencies: curl.exe（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Invoke-RestMethod http://127.0.0.1:8080/v1/models で Strata の応答とモデル名を確認
2. 無応答なら Get-NetTCPConnection -LocalPort 8080 と Strata の起動ログを確認、LM Studio は :1234 を確認
3. %LOCALAPPDATA%\hermes\config.yaml の base_url・model が稼働中のサーバーと一致するか確認
4. POST /v1/chat/completions に短いプロンプトを送り応答を確認

## Verification
/v1/models が 200 で、chat/completions が内容を返す

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. Strata 不調なら LM Studio(:1234)へ base_url を切替
2. ポート競合は Get-Process -Id (Get-NetTCPConnection -LocalPort 8080).OwningProcess で確認
3. いずれも不可なら llama-cpp skill で llama-server を直接起動

## Related
llama-cpp, model-selection, doctor

## Prohibited
- config.yaml の API キーを出力・送信しない
- 他プロセスを承認なしで kill しない
- 0.0.0.0 への外部公開をしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
