---
name: docker-compose
description: docker compose による複数コンテナ構成の管理
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - system
    category: system
  kiridev:
    namespace: kiridev
    category: system
    triggers:
    - docker compose
    - compose.yaml
    - マルチコンテナ
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - write_file
    - patch
    dependencies:
    - docker
    conflicts: []
    workflow: see '## Procedure'
    verification: docker compose ps が全サービス running/healthy
    fallback:
    - docker-compose (v1) コマンドに切替
    - 'ポート競合: Get-NetTCPConnection -LocalPort で解消'
    - サービス単体を docker run で再現
    risk_level: medium
    related:
    - docker
    - wsl-linux
    - debugging
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# docker-compose

docker compose による複数コンテナ構成の管理

## When to Use
Trigger: docker compose, compose.yaml, マルチコンテナ

## Tools
- required: terminal, read_file
- optional: write_file, patch
- dependencies: docker（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. docker compose config で展開後の構成を検証する
2. docker compose up -d --build で起動する
3. docker compose ps と docker compose logs -f --tail 100 <svc> で確認する
4. healthcheck と depends_on: condition: service_healthy を確認する
5. 停止は docker compose down(-v は承認後のみ)

## Verification
docker compose ps が全サービス running/healthy

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. docker-compose (v1) コマンドに切替
2. ポート競合: Get-NetTCPConnection -LocalPort で解消
3. サービス単体を docker run で再現

## Related
docker, wsl-linux, debugging

## Prohibited
- down -v でボリュームを承認なしで削除しない
- .env の Secret を出力/コミットしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
