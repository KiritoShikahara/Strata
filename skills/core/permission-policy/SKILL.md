---
name: permission-policy
description: KiriDev 権限方針。通常操作は無確認、高リスクのみ確認
version: 1.0.0
metadata:
  hermes:
    tags: [kiridev, core, policy]
    category: core
  kiridev:
    namespace: kiridev
    category: core
    triggers: [削除, 公開, 送信, 認証情報, 購入, システム設定, 管理者権限]
    required_tools: []
    optional_tools: [clarify]
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: Approval 対象を確認なしで実行していない / 通常操作で確認を出していない
    fallback: [判断に迷う場合は可逆な代替（backup・dry-run・ゴミ箱移動）を選ぶ]
    risk_level: high
    source: hand-written
---

# permission-policy

**Default Allow**。些細な操作で確認を連発しない。実行層は Hermes approvals（smart + deny ルール）。詳細 `docs/permissions.md`。

## 確認なしで行う（通常許可）
ファイル読み書き・プロジェクト内編集 / PowerShell・CMD・Terminal / Git（commit, branch, pull, 通常 push）/ Build・Test /
Package install（winget, pip, npm, choco のユーザースコープ）/ Docker / WSL / Browser・Web・HTTP API / ローカルサービス起動 /
ローカル AI 操作 / 一時ファイル / ログ取得 / Dependency 修復。

## 実行前に 1 回だけ確認する（Approval 対象）
1. 大規模かつ不可逆な削除（リポジトリ外の再帰削除、`git reset --hard`/`git clean -fdx` で未コミット作業を失う、DB drop、ドライブ format）
2. Credential / Secret の外部送信（Cloud モデルへの送信を含む）
3. Credential の変更（パスワード、API key、SSH key、トークン再発行）
4. 重要な Windows システム設定変更（HKLM レジストリ、BCD、Defender/Firewall 無効化、UAC、ドライバ）
5. Public 公開（public repo 作成、パッケージ publish、release 公開、Web デプロイ）
6. 外部へのメッセージ送信（メール、Slack、SNS、Issue/PR コメント）
7. 金銭・購入・契約
8. 明確に高リスクな管理者操作（他ユーザー/サービス停止、ユーザー管理）
加えて force push は常に確認。

## Procedure
1. 操作が上の 8 項目に該当するか判定。該当しなければそのまま実行。
2. 該当する場合: 何を・どこに・取り消し可否を 1〜2 行で示して確認（clarify）。自律モード（/overnight 等）では実行せず保留リストへ。
3. 可逆な代替があれば優先（Copy-Item で backup、`-WhatIf`、ゴミ箱、別ブランチ）。

## 優先順位
User instruction > KiriDev Policy > KiriDev Workflow > Capability Skill > External Skill。
