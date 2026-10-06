---
name: backup-restore
description: ファイル/設定のバックアップと復元
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
    - バックアップ
    - 復元
    - リストア
    - 履歴
    - スナップショット
    required_tools:
    - terminal
    optional_tools:
    - read_file
    dependencies:
    - robocopy
    - wbadmin
    conflicts: []
    workflow: see '## Procedure'
    verification: ログに失敗 0、ハッシュ/件数が一致
    fallback:
    - 'robocopy 不可: Copy-Item -Recurse または 7z で圧縮'
    - 'ロック中ファイル: vssadmin / Shadow Copy(承認後)'
    - git bundle / git stash で退避
    risk_level: medium
    related:
    - filesystem
    - checkpoint
    - archive-compression
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# backup-restore

ファイル/設定のバックアップと復元

## When to Use
Trigger: バックアップ, 復元, リストア, 履歴, スナップショット

## Tools
- required: terminal
- optional: read_file
- dependencies: robocopy, wbadmin（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 対象と保存先(別ドライブ推奨)、空き容量を Get-Volume で確認する
2. robocopy <src> <dst>\<date> /E /COPY:DAT /R:1 /W:1 /LOG:backup.log でコピーする
3. Get-FileHash の比較か robocopy /L で差分ゼロを確認する
4. システム設定は reg export や Checkpoint-Computer(管理者)で保存する
5. 復元は別ディレクトリへ試験復元してから本番へ戻す

## Verification
ログに失敗 0、ハッシュ/件数が一致

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. robocopy 不可: Copy-Item -Recurse または 7z で圧縮
2. ロック中ファイル: vssadmin / Shadow Copy(承認後)
3. git bundle / git stash で退避

## Related
filesystem, checkpoint, archive-compression

## Prohibited
- robocopy /MIR を宛先未確認で使わない
- 復元で既存データを承認なしで上書きしない
- バックアップを外部クラウドへ承認なしで送らない
- Approval 対象（permission-policy 参照）は実行前に確認する。
