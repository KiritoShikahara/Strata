---
name: filesystem
description: ファイル・フォルダの検索・コピー・移動・整理
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
    - ファイル検索
    - コピー
    - 移動
    - フォルダ
    - 整理
    required_tools:
    - terminal
    - search_files
    - read_file
    optional_tools:
    - write_file
    - patch
    dependencies:
    - robocopy
    conflicts: []
    workflow: see '## Procedure'
    verification: Get-ChildItem 件数と Get-FileHash が期待どおり一致する
    fallback:
    - 'robocopy 失敗: Copy-Item -Recurse に切替'
    - 'アクセス拒否: permissions-acl で ACL を確認し管理者権限を依頼'
    - 'ロック中: process-management で保持プロセスを特定'
    - WSL の rsync / find を使う
    risk_level: medium
    related:
    - powershell
    - permissions-acl
    - backup-restore
    - checkpoint
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# filesystem

ファイル・フォルダの検索・コピー・移動・整理

## When to Use
Trigger: ファイル検索, コピー, 移動, フォルダ, 整理

## Tools
- required: terminal, search_files, read_file
- optional: write_file, patch
- dependencies: robocopy（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Get-ChildItem -Recurse -File -Filter <pat> で対象を列挙し件数とサイズを集計する
2. Test-Path / Get-FileHash -Algorithm SHA256 で存在と同一性を確認する
3. 大量コピーは robocopy <src> <dst> /E /R:1 /W:1 /LOG:<file> を使う
4. 削除・上書きは先に一覧を提示し Move-Item で退避してから行う
5. 長いパスは \\?\ プレフィックスか LongPathsEnabled を確認する

## Verification
Get-ChildItem 件数と Get-FileHash が期待どおり一致する

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. robocopy 失敗: Copy-Item -Recurse に切替
2. アクセス拒否: permissions-acl で ACL を確認し管理者権限を依頼
3. ロック中: process-management で保持プロセスを特定
4. WSL の rsync / find を使う

## Related
powershell, permissions-acl, backup-restore, checkpoint

## Prohibited
- 大量・不可逆削除は承認なしで行わない
- robocopy /MIR /PURGE を宛先確認なしで使わない
- C:\Windows や他ユーザープロファイルを変更しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
