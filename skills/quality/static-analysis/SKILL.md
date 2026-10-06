---
name: static-analysis
description: 静的解析でバグ・脆弱性・危険パターンを検出
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - quality
    category: quality
  kiridev:
    namespace: kiridev
    category: quality
    triggers:
    - 静的解析
    - セキュリティスキャン
    - bandit
    - semgrep
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - search_files
    dependencies:
    - bandit
    - semgrep
    - pip-audit
    - npm
    conflicts: []
    workflow: see '## Procedure'
    verification: 再実行で重大指摘が0、または残件が理由付きで一覧化されている
    fallback:
    - bandit 無し → pip install bandit
    - semgrep 無し → Docker (semgrep/semgrep) / WSL
    - '代替: ruff --select S / eslint-plugin-security'
    risk_level: low
    related:
    - lint-typecheck
    - code-review
    - permission-policy
    - doctor
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# static-analysis

静的解析でバグ・脆弱性・危険パターンを検出

## When to Use
Trigger: 静的解析, セキュリティスキャン, bandit, semgrep

## Tools
- required: terminal, read_file
- optional: search_files
- dependencies: bandit, semgrep, pip-audit, npm（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Python: bandit -r src -ll; pip-audit; JS: npm audit --omit=dev
2. semgrep --config auto . （可能なら）
3. シークレット混入確認: rg -n "(api[_-]?key|secret|token)\s*=" （値は出力に出さない）
4. 検出を 重大度×到達可能性 で選別し誤検知を除外（理由を記載）
5. 修正または抑制は根拠付きで行う

## Verification
再実行で重大指摘が0、または残件が理由付きで一覧化されている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. bandit 無し → pip install bandit
2. semgrep 無し → Docker (semgrep/semgrep) / WSL
3. 代替: ruff --select S / eslint-plugin-security

## Related
lint-typecheck, code-review, permission-policy, doctor

## Prohibited
- 検出されたシークレット値を出力/外部送信しない
- 外部 SaaS へコードをアップロードしない（承認が必要）
- 指摘を理由なく noqa で消さない
- Approval 対象（permission-policy 参照）は実行前に確認する。
