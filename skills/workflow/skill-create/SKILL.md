---
name: skill-create
description: KiriDev 形式の新 Skill を作成し index 更新と同期まで行う
version: 1.0.0
metadata:
  hermes:
    tags: [kiridev, workflow, skills]
    category: workflow
  kiridev:
    namespace: kiridev
    category: workflow
    triggers: [/skill-create, Skill を作って, この手順を Skill 化, 繰り返し作業の定型化]
    required_tools: [write_file, terminal]
    optional_tools: [skill_view, skill_manage]
    dependencies: [python, powershell]
    conflicts: []
    workflow: see '## Procedure'
    verification: kiridev_skills.py check が 0 errors、sync 後 hermes skills list に表示される
    fallback: [KiriDev repo が無い環境 → Hermes skill_manage で ~/.hermes/skills に直接作成]
    risk_level: low
    source: hand-written
---

# skill-create

正本は KiriDev repo（Strata repo の `skills/`）。Hermes の skills dir は同期先。外部の作法は external `skill-creator`（Anthropic）、
Hermes の作法は bundled `hermes-agent-skill-authoring` を参照。

## Procedure
1. 既存 Skill と重複しないか `skills/index.md` を検索。重複なら既存を改善する（共通化）。
2. 種別を決める:
   - Capability Skill → `skills/catalog/<category>.yaml` にエントリ追加（`skills/catalog/SCHEMA.md`）。
   - Workflow / Core / 独自スクリプト付き → `skills/<category>/<name>/SKILL.md` を手書き（frontmatter は既存 core Skill に倣う）。
3. 必須: 必要になる条件・使用 Tool・標準 Workflow・Verification・Fallback・連携 Skill・禁止事項。description は 60 文字以内。一般論を書かない。
4. 生成と検査: `& "$env:LOCALAPPDATA\hermes\hermes-agent\venv\Scripts\python.exe" scripts\kiridev_skills.py build` → `... check`。
5. 同期: `powershell -File scripts\sync-hermes-skills.ps1` → `hermes skills list | Select-String <name>`。
