---
name: docker
description: Docker コンテナ/イメージの実行と管理
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
    - docker
    - コンテナ
    - イメージ
    - Dockerfile
    required_tools:
    - terminal
    optional_tools:
    - read_file
    - write_file
    dependencies:
    - docker
    conflicts: []
    workflow: see '## Procedure'
    verification: docker ps に期待コンテナが Up、またはコンテナ終了コードが 0
    fallback:
    - 'デーモン停止: Docker Desktop 起動 / wsl --status 確認'
    - '不在: winget install Docker.DockerDesktop'
    - WSL 内の docker/podman を使う
    - Windows Sandbox / VM で代替
    risk_level: medium
    related:
    - docker-compose
    - wsl-linux
    - secret-scan
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# docker

Docker コンテナ/イメージの実行と管理

## When to Use
Trigger: docker, コンテナ, イメージ, Dockerfile

## Tools
- required: terminal
- optional: read_file, write_file
- dependencies: docker（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. docker version と docker info でデーモン稼働(Docker Desktop/WSL2)を確認する
2. docker build -t <name>:<tag> . で作成、docker run --rm -it -v "${PWD}:/work" <img> で実行する
3. docker ps -a / docker logs --tail 100 <c> で状態を確認する
4. docker inspect <c> で env/mount/port を確認する
5. 不要物は docker system df で確認してから個別に削除する

## Verification
docker ps に期待コンテナが Up、またはコンテナ終了コードが 0

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. デーモン停止: Docker Desktop 起動 / wsl --status 確認
2. 不在: winget install Docker.DockerDesktop
3. WSL 内の docker/podman を使う
4. Windows Sandbox / VM で代替

## Related
docker-compose, wsl-linux, secret-scan

## Prohibited
- docker system prune -a --volumes を承認なしで実行しない
- --privileged やホスト全体マウントを不要に使わない
- Secret をイメージに焼き込まない
- レジストリへ承認なしで push しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
