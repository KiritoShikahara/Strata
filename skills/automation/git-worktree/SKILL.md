---
name: git-worktree
description: git worktree で並行作業用の独立作業ツリーを使う
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
    - worktree
    - 並行ブランチ
    - 別ブランチで作業
    - /worktree
    required_tools:
    - terminal
    optional_tools:
    - read_file
    dependencies:
    - git
    conflicts: []
    workflow: see '## Procedure'
    verification: git worktree list に期待通り表示、削除後に prune 済み
    fallback:
    - worktree 不可 → git clone --local / 別ブランチ + stash
    - 長いパス問題 → git config core.longpaths true
    risk_level: low
    related:
    - git
    - parallel-execution
    - subagent-delegation
    - checkpoint
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# git-worktree

git worktree で並行作業用の独立作業ツリーを使う

## When to Use
Trigger: worktree, 並行ブランチ, 別ブランチで作業, /worktree

## Tools
- required: terminal
- optional: read_file
- dependencies: git（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. git worktree list で現状確認、git status がクリーンか確認
2. git worktree add ..\repo-feat -b feat/x main （/worktree でも可）
3. 新ツリーで作業・テスト（node_modules/venv は別途用意）
4. 完了後マージ/PR 化 → git worktree remove ..\repo-feat; git worktree prune

## Verification
git worktree list に期待通り表示、削除後に prune 済み

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. worktree 不可 → git clone --local / 別ブランチ + stash
2. 長いパス問題 → git config core.longpaths true

## Related
git, parallel-execution, subagent-delegation, checkpoint

## Prohibited
- 未コミット変更のある worktree を --force 削除しない
- push/マージは承認なしにしない
- 同一ブランチを複数ツリーで checkout しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
