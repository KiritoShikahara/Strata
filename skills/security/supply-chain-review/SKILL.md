---
name: supply-chain-review
description: 依存・ビルド・配布物のサプライチェーンリスク確認
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
    - サプライチェーン
    - typosquatting
    - 署名
    - postinstall
    - 配布物
    required_tools:
    - terminal
    - read_file
    optional_tools:
    - web_search
    - web_extract
    dependencies:
    - npm
    - pip
    - git
    conflicts: []
    workflow: see '## Procedure'
    verification: 各依存に出所・署名/ハッシュ確認結果とリスク判定がある
    fallback:
    - osv-scanner / socket.dev / npm audit signatures
    - Docker/Windows Sandbox で隔離して検査
    - 代替の信頼できるライブラリを提案
    - 不明なら導入を保留しユーザーに確認
    risk_level: medium
    related:
    - dependency-audit
    - package-management
    - software-installation
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# supply-chain-review

依存・ビルド・配布物のサプライチェーンリスク確認

## When to Use
Trigger: サプライチェーン, typosquatting, 署名, postinstall, 配布物

## Tools
- required: terminal, read_file
- optional: web_search, web_extract
- dependencies: npm, pip, git（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 新規/更新依存の名称類似(typosquat)・メンテナ・公開日・DL 数を npm view / pip index versions で確認する
2. package.json の scripts(preinstall/postinstall) と setup.py/pyproject のビルドフックを読む
3. npm install --ignore-scripts や pip download --no-deps で取得だけ行い内容を検査する
4. Get-FileHash と Get-AuthenticodeSignature、公式の checksum/署名と照合する
5. CI の uses: アクションをコミット SHA に固定されているか確認する

## Verification
各依存に出所・署名/ハッシュ確認結果とリスク判定がある

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. osv-scanner / socket.dev / npm audit signatures
2. Docker/Windows Sandbox で隔離して検査
3. 代替の信頼できるライブラリを提案
4. 不明なら導入を保留しユーザーに確認

## Related
dependency-audit, package-management, software-installation

## Prohibited
- 未検証パッケージを本環境へ導入・実行しない
- 承認なしで publish/リリースしない
- 検査対象のスクリプトを隔離なしで実行しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
