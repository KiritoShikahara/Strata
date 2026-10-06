---
name: storage-management
description: ディスク・パーティション・容量の確認と整理
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
    - ディスク
    - 容量
    - パーティション
    - ドライブ
    - 空き
    required_tools:
    - terminal
    optional_tools: []
    dependencies:
    - powershell
    conflicts: []
    workflow: see '## Procedure'
    verification: Get-Volume の SizeRemaining が期待どおり
    fallback:
    - cleanmgr / Storage Sense の手順を案内
    - WizTree / TreeSize を winget で導入
    - dism /Online /Cleanup-Image /AnalyzeComponentStore
    risk_level: high
    related:
    - filesystem
    - backup-restore
    - hardware-diagnostics
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# storage-management

ディスク・パーティション・容量の確認と整理

## When to Use
Trigger: ディスク, 容量, パーティション, ドライブ, 空き

## Tools
- required: terminal
- optional: -
- dependencies: powershell（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Get-Volume と Get-Disk | Get-Partition で構成と空き容量を確認する
2. Get-ChildItem <dir> -Recurse -File | Group-Object Directory | 合計サイズ降順 で大容量箇所を特定する
3. Optimize-Volume -DriveLetter C -Analyze で最適化要否を確認する
4. 削除候補は一覧を提示し承認後に実施する(Clear-RecycleBin 等)
5. 操作後に Get-Volume で空き容量の変化を確認する

## Verification
Get-Volume の SizeRemaining が期待どおり

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. cleanmgr / Storage Sense の手順を案内
2. WizTree / TreeSize を winget で導入
3. dism /Online /Cleanup-Image /AnalyzeComponentStore

## Related
filesystem, backup-restore, hardware-diagnostics

## Prohibited
- Format-Volume / Clear-Disk / diskpart clean を承認なしで実行しない
- パーティション変更を承認なしで行わない
- WinSxS を手動削除しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
