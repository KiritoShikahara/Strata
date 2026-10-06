---
name: skill-update
description: skill の追加・更新を catalog から生成し Hermes へ同期
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
    - スキル更新
    - skill同期
    - sync
    - カタログ更新
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - skill_manage
    - patch
    dependencies:
    - python
    - pwsh
    conflicts: []
    workflow: see '## Procedure'
    verification: build が成功し、skills_list に新規/更新 skill が表示される
    fallback:
    - sync スクリプト失敗 → 出力先ディレクトリを手動確認し Copy-Item で配置
    - skill_manage ツールで個別登録
    - powershell.exe 5.1 でも実行を試す
    risk_level: low
    related:
    - self-update
    - strata
    - filesystem
    - git
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# skill-update

skill の追加・更新を catalog から生成し Hermes へ同期

## When to Use
Trigger: スキル更新, skill同期, sync, カタログ更新

## Tools
- required: terminal, read_file
- optional: skill_manage, patch
- dependencies: python, pwsh（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. skills/catalog/<category>.yaml を編集（SCHEMA.md 準拠、d は 60 文字以内）
2. YAML 検証: python -c "import yaml;yaml.safe_load(open(f,encoding='utf-8'))"
3. python scripts/kiridev_skills.py build で SKILL.md を生成（手書き SKILL.md は上書きされない）
4. pwsh scripts\sync-hermes-skills.ps1 で Hermes へ同期
5. skills_list / skill_view で反映を確認し git diff で変更を確認

## Verification
build が成功し、skills_list に新規/更新 skill が表示される

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. sync スクリプト失敗 → 出力先ディレクトリを手動確認し Copy-Item で配置
2. skill_manage ツールで個別登録
3. powershell.exe 5.1 でも実行を試す

## Related
self-update, strata, filesystem, git

## Prohibited
- 手書き SKILL.md を上書きしない
- 同期先の無関係な skill を削除しない
- commit/push は承認なしにしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
