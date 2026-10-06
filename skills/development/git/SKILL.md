---
name: git
description: Git の status/diff/log/branch/stash/worktree 操作
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - development
    category: development
  kiridev:
    namespace: kiridev
    category: development
    triggers:
    - git
    - commit
    - branch
    - diff
    - stash
    - worktree
    - 履歴
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - search_files
    dependencies:
    - git
    conflicts: []
    workflow: see '## Procedure'
    verification: git status -sb がクリーンで git log -1 --stat が意図した変更のみを示す
    fallback:
    - Get-Command git で確認し無ければ winget install Git.Git
    - GitHub Desktop / VS Code の Source Control を使う
    - 履歴が壊れたら git reflog から復元点を探す
    risk_level: medium
    related:
    - filesystem
    - powershell
    - checkpoint
    - debugging
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# git

Git の status/diff/log/branch/stash/worktree 操作

## When to Use
Trigger: git, commit, branch, diff, stash, worktree, 履歴

## Tools
- required: terminal, read_file
- optional: search_files
- dependencies: git（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. git status -sb と git diff --stat で現状と変更範囲を確認する
2. git log --oneline --graph -20 で履歴を把握し、git branch -vv でブランチ関係を見る
3. 作業退避は git stash push -u -m "msg"、並行作業は git worktree add ..\wt-<name> <branch> を使う
4. git add -p で意図した hunk のみステージし git commit -m で小さくコミットする
5. 取り込みは git fetch 後に git merge --ff-only か git rebase を使い、衝突は git diff --name-only --diff-filter=U で特定する

## Verification
git status -sb がクリーンで git log -1 --stat が意図した変更のみを示す

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. Get-Command git で確認し無ければ winget install Git.Git
2. GitHub Desktop / VS Code の Source Control を使う
3. 履歴が壊れたら git reflog から復元点を探す

## Related
filesystem, powershell, checkpoint, debugging

## Prohibited
- force-push と git reset --hard と git clean -fd は承認なしで実行しない
- .env や認証情報をコミットしない。push/公開は承認が必要
- Approval 対象（permission-policy 参照）は実行前に確認する。
