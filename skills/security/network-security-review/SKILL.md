---
name: network-security-review
description: 公開ポート・FW・TLS 設定のセキュリティ確認
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - security
    category: security
  kiridev:
    namespace: kiridev
    category: security
    triggers:
    - ポート開放
    - ファイアウォール
    - TLS
    - 待受
    - 外部公開
    required_tools:
    - terminal
    optional_tools:
    - web_search
    dependencies:
    - powershell
    - netstat
    conflicts: []
    workflow: see '## Procedure'
    verification: 待受/規則/TLS の一覧と各リスク評価を提示
    fallback:
    - netstat -ano | findstr LISTENING
    - nmap (winget install Insecure.Nmap) を自ホストのみに使用
    - openssl s_client -connect <host>:443
    - WSL の ss -tlnp
    risk_level: medium
    related:
    - network-diagnostics
    - security-review
    - permission-audit
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# network-security-review

公開ポート・FW・TLS 設定のセキュリティ確認

## When to Use
Trigger: ポート開放, ファイアウォール, TLS, 待受, 外部公開

## Tools
- required: terminal
- optional: web_search
- dependencies: powershell, netstat（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Get-NetTCPConnection -State Listen | Select LocalAddress,LocalPort,OwningProcess でリッスンを列挙する
2. 0.0.0.0/:: 待受をプロセス名と突合し不要なものを抽出する
3. Get-NetFirewallRule -Enabled True -Direction Inbound -Action Allow で許可規則を確認する
4. 自ホスト/許可済み対象に限り Test-NetConnection と curl.exe -vI https://<host> で TLS 版・証明書期限を確認する
5. 所見と是正案(バインドを 127.0.0.1 に限定等)を報告する

## Verification
待受/規則/TLS の一覧と各リスク評価を提示

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. netstat -ano | findstr LISTENING
2. nmap (winget install Insecure.Nmap) を自ホストのみに使用
3. openssl s_client -connect <host>:443
4. WSL の ss -tlnp

## Related
network-diagnostics, security-review, permission-audit

## Prohibited
- 承認なしで第三者/外部ホストをスキャンしない
- FW 規則・ポート設定を承認なしで変更しない
- Defender/FW の無効化をしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
