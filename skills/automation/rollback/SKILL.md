---
name: rollback
description: 変更を /rollback・/snapshot・git で安全に巻き戻す
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
    - ロールバック
    - 元に戻す
    - 巻き戻し
    - undo
    - revert
    required_tools:
    - terminal
    optional_tools:
    - read_file
    dependencies:
    - git
    conflicts: []
    workflow: see '## Procedure'
    verification: git diff / git status が期待状態で、テストが通る
    fallback:
    - checkpoint 無し → git reflog から復旧
    - git 管理外 → バックアップ (*.bak) や Windows のファイル履歴/シャドウコピー
    - 復旧不能箇所は明示して報告
    risk_level: high
    related:
    - checkpoint
    - git
    - failure-recovery
    - permission-policy
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# rollback

変更を /rollback・/snapshot・git で安全に巻き戻す

## When to Use
Trigger: ロールバック, 元に戻す, 巻き戻し, undo, revert

## Tools
- required: terminal
- optional: read_file
- dependencies: git（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. /snapshot で現在状態を保存してから戻す（巻き戻しも元に戻せるように）
2. 対象を特定: /rollback の一覧、git log --oneline、git status
3. 未コミットは git restore <path>、コミット済は git revert <sha>（履歴を残す）
4. /rollback でファイルシステム checkpoint から復元
5. 復元後にテスト/diff で状態を確認

## Verification
git diff / git status が期待状態で、テストが通る

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. checkpoint 無し → git reflog から復旧
2. git 管理外 → バックアップ (*.bak) や Windows のファイル履歴/シャドウコピー
3. 復旧不能箇所は明示して報告

## Related
checkpoint, git, failure-recovery, permission-policy

## Prohibited
- git reset --hard / clean -fd / force push は承認なしに実行しない
- 他者・未保存の変更を巻き込んで破棄しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
