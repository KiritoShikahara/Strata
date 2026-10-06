---
name: diagnose
description: 再現→証拠→仮説→計測→根本原因→修正→回帰テスト→検証
version: 1.0.0
metadata:
  hermes:
    tags: [kiridev, workflow, debugging]
    category: workflow
  kiridev:
    namespace: kiridev
    category: workflow
    triggers: [/diagnose, バグ, 落ちる, 遅い, 原因を調べて, 再現する]
    required_tools: [terminal, read_file, search_files]
    optional_tools: [patch, delegate_task, web_search]
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 再現手順が修正後に失敗しなくなり、回帰テストが追加され、verify が通る
    fallback: [再現できない → ログ/計測点を追加して再試行 → 環境差分（doctor）→ 二分探索（git bisect）]
    risk_level: low
    source: hand-written
---

# diagnose

**推測だけで修正しない。** bundled `systematic-debugging` Skill も参照可。

## Procedure
1. **Reproduce**: 最小の再現コマンド/手順を作り、実際に失敗を観測する（出力を保存）。
2. **Collect evidence**: エラー全文・スタック・ログ（Event Viewer: `Get-WinEvent -LogName Application -MaxEvents 50`）・直近の変更（`git log -p -5`, `git diff`）。
3. **Generate hypotheses**: 根拠つきで 2〜4 個。各仮説に「正しければ観測できること」を書く。
4. **Measure**: ログ追加・デバッガ・プロファイラ・`git bisect` で仮説を 1 つずつ検証して絞る。
5. **Identify root cause**: 症状ではなく原因を 1 文で特定（file:line）。
6. **Fix**: 最小修正。
7. **Regression test**: 再現手順をテスト化（失敗→成功を確認）。
8. **Verify**: `verify` Skill を実行。

## Report
原因（file:line）/ 根拠 / 修正 / 追加テスト / verify 結果。
