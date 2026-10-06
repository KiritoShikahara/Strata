---
name: network-diagnostics
description: 接続・DNS・ポート・経路の診断
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
    - ネットワーク
    - ping
    - DNS
    - 接続できない
    - ポート
    required_tools:
    - terminal
    optional_tools:
    - web_search
    dependencies:
    - powershell
    conflicts: []
    workflow: see '## Procedure'
    verification: 'TcpTestSucceeded : True、または原因層(DNS/経路/FW/サービス)を特定'
    fallback:
    - 'Test-NetConnection 不可: curl.exe -v / nslookup'
    - ipconfig /all と netsh interface ip show config
    - Wireshark/pktmon (pktmon start --capture) でキャプチャ
    - WSL の dig/traceroute
    risk_level: low
    related:
    - http-api
    - network-security-review
    - logs-event-viewer
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# network-diagnostics

接続・DNS・ポート・経路の診断

## When to Use
Trigger: ネットワーク, ping, DNS, 接続できない, ポート

## Tools
- required: terminal
- optional: web_search
- dependencies: powershell（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Get-NetIPConfiguration でアドレス/GW/DNS を確認する
2. Test-Connection <host> -Count 4 で到達性を確認する
3. Test-NetConnection <host> -Port <p> でポート疎通を確認する
4. Resolve-DnsName <host> -Server 1.1.1.1 と既定 DNS を比較する
5. tracert / pathping で経路を調べ、Get-NetTCPConnection でローカル待受を確認する

## Verification
TcpTestSucceeded : True、または原因層(DNS/経路/FW/サービス)を特定

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. Test-NetConnection 不可: curl.exe -v / nslookup
2. ipconfig /all と netsh interface ip show config
3. Wireshark/pktmon (pktmon start --capture) でキャプチャ
4. WSL の dig/traceroute

## Related
http-api, network-security-review, logs-event-viewer

## Prohibited
- 承認なしでポートスキャン(外部ホスト)をしない
- ネットワーク設定/FW 規則/DNS を承認なしで変更しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
