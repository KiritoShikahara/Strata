---
name: fallback-model-routing
description: モデル障害・能力不足時の代替モデル経路と検証手順
version: 1.0.0
metadata:
  hermes:
    tags: [kiridev, core, fallback, model]
    category: core
  kiridev:
    namespace: kiridev
    category: core
    triggers: [model-capability-gap, rate-limit, network-failure, モデルが応答しない]
    required_tools: [terminal]
    optional_tools: [vision_analyze]
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 代替モデルの出力を Local でビルド/テスト検証した
    fallback: [model-router の昇格手順]
    risk_level: medium
    source: hand-written
---

# fallback-model-routing

## 2 種類の fallback
- **障害 fallback（自動）**: Hermes `fallback_providers`。接続不可/5xx/429/401/404 で turn 内に自動切替。次 turn で primary に戻る。
- **能力 fallback（判断）**: 応答はあるが品質不足。下の順で進む。

## Procedure（能力 fallback）
1. Strata のまま Skill/Context を改善（関連ファイルだけ渡す、手順を Skill から読む）。
2. Context 縮小（/compress、タスク分割、delegate_task で子に要約させる）。
3. 別ローカルモデル（LM Studio の別モデル: `lms ls` で確認）。
4. 専用モデル（vision → vision_analyze、embedding → nomic-embed）。
5. Cloud（model-router の昇格実行）。
6. 各段で結果を検証し、成功した route を `kdlog.py event fallback` に記録。

## Prohibited
- 失敗の分類（docs/fallback.md の Failure Class）をせずに Cloud へ直行すること。
