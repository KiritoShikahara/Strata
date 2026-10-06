---
name: retro
description: 作業の振り返りから Skill/Routing/Fallback 改善候補を出す
version: 1.0.0
metadata:
  hermes:
    tags: [kiridev, workflow, retrospective]
    category: workflow
  kiridev:
    namespace: kiridev
    category: workflow
    triggers: [/retro, 振り返り, 何がうまくいかなかった, 改善点]
    required_tools: [terminal]
    optional_tools: [session_search, read_file]
    dependencies: [python]
    conflicts: []
    workflow: see '## Procedure'
    verification: 改善候補が具体的な Skill ファイル・変更内容つきで出ている
    fallback: [kdlog が空 → 会話履歴と git log だけで実施]
    risk_level: low
    source: hand-written
---

# retro

## Procedure
1. 材料: 今回の会話、`git log --oneline -20`、`kdlog.py tail -n 50`（failure/fallback/route）、/verify 結果。
2. 分類: うまくいったこと / 失敗と回復 / 時間を浪費したこと。
3. 改善候補を生成（Self Improvement）: Skill 改善・Trigger 改善・Workflow 改善・Tool routing・Model routing・Fallback。
   各候補 = 対象ファイル（例 `skills/system/powershell/SKILL.md` or catalog）+ 変更案 + 根拠。
4. **Core Policy（skills/core/*、permission-policy）は提案のみ**。Capability Skill の小修正は KiriDev repo 側を編集し sync してよい。
5. Hermes の `/refine`（background skill review）も併用可。

## Report
良かった点 3 / 問題 3 / 改善候補（優先順、最大 5）。
