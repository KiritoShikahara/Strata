---
name: research
description: 一次情報優先で調査し、出典つきで結論を出す（/research）
version: 1.0.0
metadata:
  hermes:
    tags: [kiridev, workflow, research]
    category: workflow
  kiridev:
    namespace: kiridev
    category: workflow
    triggers: [/research, 調べて, 比較して, 最新情報, 公式ドキュメント]
    required_tools: [web_search, web_extract]
    optional_tools: [browser_navigate, delegate_task, terminal]
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 主要な主張すべてに一次情報の URL があり、日付/バージョンが明記されている
    fallback: [web toolset 不可 → curl/Invoke-WebRequest + gh api → browser_* → 既知の公式ドキュメント URL を直接取得]
    risk_level: low
    source: hand-written
---

# research

## Procedure
1. 問いを 1〜3 個の検証可能な質問に分解。必要なら deep-research / github-research / technical-docs-research Skill をロード。
2. **Primary source first**: 公式ドキュメント、公式リポジトリ（README, LICENSE, releases, CHANGELOG）、仕様書、論文、一次発表。
   GitHub は `gh api repos/<owner>/<repo>`（スター、更新日、ライセンス）で真偽を確認。同名 fork・偽物に注意。
3. 二次情報（ブログ・SNS）は補強のみ。矛盾があれば一次情報を優先し、矛盾自体を報告。
4. 広い調査は `delegate_task` で並列化し、要約と URL だけ受け取る。
5. 結論 → 根拠（URL + 取得日）→ 不確実な点 の順で報告。
