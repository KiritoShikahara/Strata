---
name: remote-desktop-assist
description: リモートデスクトップ接続と画面共有の支援
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
    - RDP
    - リモートデスクトップ
    - mstsc
    - 画面共有
    required_tools:
    - terminal
    - computer_use
    optional_tools:
    - vision_analyze
    dependencies:
    - mstsc
    conflicts: []
    workflow: see '## Procedure'
    verification: mstsc でデスクトップが表示され、サインアウト後にセッション一覧に残らない(query user)
    fallback:
    - Quick Assist / Windows App を案内
    - SSH ポートフォワード経由で RDP (ssh -L 3389)
    - RustDesk 等 (winget) を提案
    risk_level: high
    related:
    - ssh
    - network-diagnostics
    - windows-control
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# remote-desktop-assist

リモートデスクトップ接続と画面共有の支援

## When to Use
Trigger: RDP, リモートデスクトップ, mstsc, 画面共有

## Tools
- required: terminal, computer_use
- optional: vision_analyze
- dependencies: mstsc（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Test-NetConnection <host> -Port 3389 で RDP 疎通を確認する
2. .rdp ファイルを作成し mstsc <file>.rdp で接続する
3. 接続不可なら HKLM:\System\CurrentControlSet\Control\Terminal Server の fDenyTSConnections を読取確認する
4. NLA/資格情報はユーザー入力に委ね、画面確認は computer_use のスクリーンショットで行う
5. 作業後にセッションを切断/サインアウトする

## Verification
mstsc でデスクトップが表示され、サインアウト後にセッション一覧に残らない(query user)

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. Quick Assist / Windows App を案内
2. SSH ポートフォワード経由で RDP (ssh -L 3389)
3. RustDesk 等 (winget) を提案

## Related
ssh, network-diagnostics, windows-control

## Prohibited
- 承認なしで RDP を有効化/FW 開放しない
- 資格情報を保存・出力しない
- 3389 をインターネットへ直接公開しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
