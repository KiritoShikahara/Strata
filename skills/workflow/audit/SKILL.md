---
name: audit
description: コード/依存/権限/Secret/設定を横断監査し優先順に報告
version: 1.0.0
metadata:
  hermes:
    tags: [kiridev, workflow, security, quality]
    category: workflow
  kiridev:
    namespace: kiridev
    category: workflow
    triggers: [/audit, 監査, セキュリティチェック, 依存の脆弱性, リリース前チェック]
    required_tools: [terminal, search_files, read_file]
    optional_tools: [delegate_task]
    dependencies: [git]
    conflicts: []
    workflow: see '## Procedure'
    verification: 各観点が実コマンドの出力に基づき High/Medium/Low で分類されている
    fallback: [監査ツール未導入 → fallback Skill で導入 → 無理なら rg による静的検索で代替]
    risk_level: low
    source: hand-written
---

# audit

監査は読み取り中心。修正はユーザー依頼範囲か、明白で安全なものだけ。

## Procedure
1. 対象と観点を決める（指定が無ければ全観点）。関連 Skill: security-review, dependency-audit, secret-scan, permission-audit,
   supply-chain-review, static-analysis, dead-code-removal, overengineering-detection, release-readiness。必要なものだけロード。
2. 依存: `npm audit --omit=dev` / `pip-audit` / `dotnet list package --vulnerable` / `cargo audit`。
3. Secret: `git ls-files | rg -n` で鍵パターン、`gitleaks detect`（あれば）。.gitignore の漏れ。
4. 権限/設定: 過剰な権限、`approvals`/deny ルール、公開設定。
5. 品質: lint/型/未使用コード、過剰設計（ponytail-audit 外部 Skill も可）。
6. 報告: 重大度順の表（観点 / 箇所 file:line / 内容 / 推奨対処）。
