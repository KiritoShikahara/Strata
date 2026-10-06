---
name: ssh
description: OpenSSH による接続・鍵管理・ポート転送
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
    - ssh
    - scp
    - sftp
    - 鍵
    - ssh-keygen
    required_tools:
    - terminal
    optional_tools: []
    dependencies:
    - ssh.exe
    conflicts: []
    workflow: see '## Procedure'
    verification: ssh <host> "hostname" が成功し期待ホスト名を返す
    fallback:
    - '不在: Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0'
    - Git for Windows 同梱 ssh を使う
    - WSL の ssh を使う
    - PuTTY/plink (winget install PuTTY.PuTTY)
    risk_level: high
    related:
    - remote-execution
    - permissions-acl
    - secret-scan
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# ssh

OpenSSH による接続・鍵管理・ポート転送

## When to Use
Trigger: ssh, scp, sftp, 鍵, ssh-keygen

## Tools
- required: terminal
- optional: -
- dependencies: ssh.exe（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Get-Command ssh で OpenSSH クライアントを確認する
2. ssh-keygen -t ed25519 -f $HOME\.ssh\id_ed25519 で鍵を生成する
3. $HOME\.ssh\config に Host/HostName/User/IdentityFile を定義する
4. ssh -o BatchMode=yes -v <host> "echo ok" で接続を検証する
5. ポート転送は ssh -L <lp>:<h>:<rp> <host>、転送は scp/sftp を使う

## Verification
ssh <host> "hostname" が成功し期待ホスト名を返す

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 不在: Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
2. Git for Windows 同梱 ssh を使う
3. WSL の ssh を使う
4. PuTTY/plink (winget install PuTTY.PuTTY)

## Related
remote-execution, permissions-acl, secret-scan

## Prohibited
- 秘密鍵・パスフレーズを出力/送信しない
- StrictHostKeyChecking=no を常用しない
- 承認なしで本番ホストでコマンドを実行しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
