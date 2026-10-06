---
name: dependency-audit
description: 依存パッケージの既知脆弱性・ライセンス監査
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
    - 依存関係
    - npm audit
    - pip-audit
    - CVE
    - 脆弱性スキャン
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - web_search
    dependencies:
    - npm
    - pip-audit
    - dotnet
    conflicts: []
    workflow: see '## Procedure'
    verification: 監査コマンドの再実行で High/Critical が 0、またはリスク受容を明記
    fallback:
    - 'pip-audit 不在: pip install pip-audit'
    - osv-scanner (winget install Google.OSVScanner)
    - GitHub Advisory / osv.dev を web_search で確認
    - trivy fs . を Docker で実行
    risk_level: low
    related:
    - supply-chain-review
    - security-review
    - package-management
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# dependency-audit

依存パッケージの既知脆弱性・ライセンス監査

## When to Use
Trigger: 依存関係, npm audit, pip-audit, CVE, 脆弱性スキャン

## Tools
- required: terminal, read_file
- optional: web_search
- dependencies: npm, pip-audit, dotnet（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. ロック/マニフェスト(package-lock.json, requirements.txt, *.csproj, vcpkg.json)を特定する
2. npm audit --json / pip-audit -r requirements.txt / dotnet list package --vulnerable --include-transitive を実行する
3. 重大度・到達可能性・修正版の有無で優先付けする
4. 更新は最小バージョンの patch/minor から個別に適用しテストする
5. 更新不可は理由と緩和策を記録する

## Verification
監査コマンドの再実行で High/Critical が 0、またはリスク受容を明記

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. pip-audit 不在: pip install pip-audit
2. osv-scanner (winget install Google.OSVScanner)
3. GitHub Advisory / osv.dev を web_search で確認
4. trivy fs . を Docker で実行

## Related
supply-chain-review, security-review, package-management

## Prohibited
- npm audit fix --force を承認なしで実行しない
- ロックファイルを無断で全再生成しない
- レジストリへ publish しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
