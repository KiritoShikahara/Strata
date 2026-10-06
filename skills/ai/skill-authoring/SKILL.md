---
name: skill-authoring
description: Hermes Skill(SKILL.md)を設計・作成する
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - ai
    category: ai
  kiridev:
    namespace: kiridev
    category: ai
    triggers:
    - スキル作成
    - SKILL.md
    - skill 追加
    - 手順書化
    required_tools:
    - write_file
    - read_file
    - skill_manage
    optional_tools:
    - skill_view
    - skills_list
    dependencies:
    - python
    conflicts: []
    workflow: see '## Procedure'
    verification: build が成功し、skill_view で SKILL.md が表示される
    fallback:
    - build 失敗は YAML 構文(クォート・インデント)を yaml.safe_load で確認
    - 生成物が不足なら SKILL.md を手書きする(上書きされない)
    - python 不在は winget install Python.Python.3.12
    risk_level: low
    related:
    - skill-evaluation
    - prompt-engineering
    - strata
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# skill-authoring

Hermes Skill(SKILL.md)を設計・作成する

## When to Use
Trigger: スキル作成, SKILL.md, skill 追加, 手順書化

## Tools
- required: write_file, read_file, skill_manage
- optional: skill_view, skills_list
- dependencies: python（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. skills_list で既存と重複しないか確認する
2. skills\catalog\<category>.yaml にエントリを追加(SCHEMA.md の全フィールド)
3. python scripts\kiridev_skills.py build で SKILL.md を生成する
4. skill_view で内容を確認し、実タスクで 1 回試行して手順を修正

## Verification
build が成功し、skill_view で SKILL.md が表示される

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. build 失敗は YAML 構文(クォート・インデント)を yaml.safe_load で確認
2. 生成物が不足なら SKILL.md を手書きする(上書きされない)
3. python 不在は winget install Python.Python.3.12

## Related
skill-evaluation, prompt-engineering, strata

## Prohibited
- Secret を SKILL.md に含めない
- 既存の手書き SKILL.md を承認なしで上書きしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
