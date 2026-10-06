---
name: self-improving
description: 失敗/回復/成功パターンから Skill・Routing 改善候補を作る
version: 1.0.0
metadata:
  hermes:
    tags: [kiridev, ai, self-improvement]
    category: ai
  kiridev:
    namespace: kiridev
    category: ai
    triggers: [タスク終了後, 同じ失敗の再発, Skill 改善, /refine]
    required_tools: [terminal, read_file]
    optional_tools: [skill_manage, session_search]
    dependencies: [python]
    conflicts: []
    workflow: see '## Procedure'
    verification: 改善候補が対象ファイルと diff 案つきで出され、Core Policy は未変更
    fallback: [kdlog が無い → 会話と git log から抽出]
    risk_level: medium
    source: hand-written
---

# self-improving

Hermes 既存機能を使う: background review / curator（自動で skill 改善候補）、`/refine`（今すぐ review）。
外部の `pskoett/self-improving-agent` はライセンス表記が無いため導入せず、この Skill で代替（docs/skill-system.md）。

## Procedure
1. 材料: `kdlog.py tail -n 100`（failure / fallback / route / verify）、今回の会話、/retro の結果。
2. パターン抽出: 繰り返した失敗・効いた回復手順・Skill が無くて手探りした作業。
3. 候補生成（種類別）: Skill 改善 / Trigger 改善 / Workflow 改善 / Tool routing / Model routing / Fallback。
4. 適用範囲:
   - Capability Skill（catalog / 個別 SKILL.md）の小修正 → KiriDev repo を編集 → `kiridev_skills.py build && check` → sync。
   - **Core Policy（skills/core/*, permission-policy, model-router）は提案のみ**。ユーザー承認後に変更。
5. Hermes の skill_manage で ~/.hermes 側だけを直接変えない（次回 sync で上書きされる）。repo 側を正とする。
