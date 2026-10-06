---
name: hardware-diagnostics
description: ハードウェア情報の取得と障害診断
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
    - ハードウェア
    - スペック
    - デバイス
    - ドライバ
    - SMART
    required_tools:
    - terminal
    optional_tools: []
    dependencies:
    - powershell
    conflicts: []
    workflow: see '## Procedure'
    verification: 構成一覧とエラーデバイス/イベントの有無を提示
    fallback:
    - msinfo32 /report <file> / dxdiag /t <file>
    - wmic(旧環境のみ) や systeminfo
    - CrystalDiskInfo / HWiNFO (winget) を導入
    risk_level: low
    related:
    - gpu-nvidia
    - storage-management
    - logs-event-viewer
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# hardware-diagnostics

ハードウェア情報の取得と障害診断

## When to Use
Trigger: ハードウェア, スペック, デバイス, ドライバ, SMART

## Tools
- required: terminal
- optional: -
- dependencies: powershell（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Get-ComputerInfo / Get-CimInstance Win32_Processor,Win32_PhysicalMemory で構成を取得する
2. Get-PnpDevice -Status Error でエラーデバイスを列挙する
3. Get-PhysicalDisk | Get-StorageReliabilityCounter で SMART 相当値を見る
4. powercfg /batteryreport で電池状態を出力する
5. Get-WinEvent -FilterHashtable @{LogName='System'; Level=1,2} で WHEA/disk エラーを確認する

## Verification
構成一覧とエラーデバイス/イベントの有無を提示

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. msinfo32 /report <file> / dxdiag /t <file>
2. wmic(旧環境のみ) や systeminfo
3. CrystalDiskInfo / HWiNFO (winget) を導入

## Related
gpu-nvidia, storage-management, logs-event-viewer

## Prohibited
- ドライバ更新・BIOS 更新・デバイス無効化を承認なしで行わない
- chkdsk /f や ディスク修復を承認なしで実行しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
