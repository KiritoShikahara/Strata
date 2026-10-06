---
name: verification
description: 完了宣言前の検証原則。実行証拠なしに完了と言わない
version: 1.0.0
metadata:
  hermes:
    tags: [kiridev, quality]
    category: quality
  kiridev:
    namespace: kiridev
    category: quality
    triggers: [完了, できました, 直しました, 実装完了の報告前]
    required_tools: [terminal]
    optional_tools: [read_file]
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 報告に実行したコマンドと結果（PASS/FAIL）が含まれる
    fallback: [検証不能 → 不能な理由と未検証箇所を明記して報告]
    risk_level: low
    source: hand-written
---

# verification

詳細手順は `verify` Skill（/verify）。外部の `verification-before-completion`（obra/superpowers）も同趣旨。

## Procedure
1. 完了と言う前に、主張ごとに証拠となるコマンドを実行する（build, test, 実行, diff）。
2. 出力を読み、期待と一致することを確認（exit code だけで判断しない）。
3. 失敗・未検証があれば「完了」と書かず、残課題として報告。

## Prohibited
- テストを弱める、期待値をハードコード、検証をスキップして完了扱い。
