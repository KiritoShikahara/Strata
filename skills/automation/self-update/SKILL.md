---
name: self-update
description: hermes update で Hermes 本体を安全に更新
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - automation
    category: automation
  kiridev:
    namespace: kiridev
    category: automation
    triggers:
    - アップデート
    - hermes update
    - 更新
    - バージョンアップ
    required_tools:
    - terminal
    optional_tools:
    - read_file
    dependencies:
    - hermes
    - git
    conflicts: []
    workflow: see '## Procedure'
    verification: バージョンが上がり、hermes doctor が正常、再同期後に skills が有効
    fallback:
    - 更新失敗 → 出力を確認し hermes update を再試行 / git pull（導入元が git の場合）
    - 破損 → バックアップ・checkpoint から復元（rollback）
    - 再インストール手順を公式ドキュメントで確認
    risk_level: medium
    related:
    - skill-update
    - doctor
    - rollback
    - environment-bootstrap
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# self-update

hermes update で Hermes 本体を安全に更新

## When to Use
Trigger: アップデート, hermes update, 更新, バージョンアップ

## Tools
- required: terminal
- optional: read_file
- dependencies: hermes, git（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 現状: hermes --version; 設定/skills のバックアップ（checkpoint）を作成
2. 実行中のジョブ (hermes cron list / プロセス) が無いことを確認
3. hermes update を実行し出力を確認
4. hermes --version と hermes doctor で更新後の状態確認
5. カスタム skills は scripts\sync-hermes-skills.ps1 で再同期

## Verification
バージョンが上がり、hermes doctor が正常、再同期後に skills が有効

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 更新失敗 → 出力を確認し hermes update を再試行 / git pull（導入元が git の場合）
2. 破損 → バックアップ・checkpoint から復元（rollback）
3. 再インストール手順を公式ドキュメントで確認

## Related
skill-update, doctor, rollback, environment-bootstrap

## Prohibited
- バックアップ無しで更新しない
- 認証情報・設定を出力/送信しない
- 稼働中ジョブを中断しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
