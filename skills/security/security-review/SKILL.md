---
name: security-review
description: コード・設定の脆弱性レビューと是正案の提示
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - security
    category: security
  kiridev:
    namespace: kiridev
    category: security
    triggers:
    - セキュリティレビュー
    - 脆弱性
    - OWASP
    - 監査
    required_tools:
    - terminal
    - read_file
    - search_files
    optional_tools:
    - web_search
    - delegate_task
    dependencies:
    - semgrep
    - git
    conflicts: []
    workflow: see '## Procedure'
    verification: 指摘ごとに file:line と再現条件/根拠があり、未確認項目を明記
    fallback:
    - 'semgrep 不在: pip install semgrep / bandit / npm audit 等の言語別ツール'
    - Docker の semgrep/semgrep イメージ
    - 手動レビューのチェックリストに切替
    risk_level: low
    related:
    - dependency-audit
    - secret-scan
    - permission-audit
    - verification
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# security-review

コード・設定の脆弱性レビューと是正案の提示

## When to Use
Trigger: セキュリティレビュー, 脆弱性, OWASP, 監査

## Tools
- required: terminal, read_file, search_files
- optional: web_search, delegate_task
- dependencies: semgrep, git（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. git ls-files と構成から攻撃面(入力・認証・ファイル・実行・外部通信)を列挙する
2. search_files で eval/exec/Invoke-Expression/subprocess shell=True/SQL 文字列連結を検索する
3. semgrep --config auto <path> で自動検査する
4. 認証/認可・入力検証・パス走査・デシリアライズ・ログ内 Secret を手動確認する
5. 重大度(高/中/低)・根拠 file:line・修正案の表で報告する

## Verification
指摘ごとに file:line と再現条件/根拠があり、未確認項目を明記

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. semgrep 不在: pip install semgrep / bandit / npm audit 等の言語別ツール
2. Docker の semgrep/semgrep イメージ
3. 手動レビューのチェックリストに切替

## Related
dependency-audit, secret-scan, permission-audit, verification

## Prohibited
- 本番システムへ攻撃的テスト(スキャン/エクスプロイト)を承認なしで実施しない
- 発見した Secret を出力・外部送信しない
- 承認なしで脆弱性を公開しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
