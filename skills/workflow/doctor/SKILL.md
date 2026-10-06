---
name: doctor
description: KiriDev/Hermes/Strata 環境を診断し安全な問題は自動修復
version: 1.0.0
metadata:
  hermes:
    tags: [kiridev, workflow, diagnostics]
    category: workflow
  kiridev:
    namespace: kiridev
    category: workflow
    triggers: [/doctor, 環境がおかしい, Strata が動かない, Hermes の設定確認, 動作環境チェック]
    required_tools: [terminal]
    optional_tools: [read_file, patch]
    dependencies: [powershell]
    conflicts: []
    workflow: see '## Procedure'
    verification: 修復後に doctor.ps1 を再実行し FAIL が減った（または 0）
    fallback: [doctor.ps1 が動かない → 各項目を個別コマンドで確認（hermes --version, curl /health, Get-Command）]
    risk_level: medium
    source: hand-written
---

# doctor

KiriDev 環境そのものを診断する（Hermes / Strata / Local Model / Model API / Python / Node / Git / PowerShell / Docker / WSL /
Network / ports / Skill registry / Provider / Permissions / PATH / 環境変数）。

## Procedure
1. 実行（PowerShell）:
   `powershell -NoProfile -ExecutionPolicy Bypass -File "$env:LOCALAPPDATA\hermes\skills\workflow\doctor\scripts\doctor.ps1"`
   （JSON が欲しい時は `-Json`。Strata の場所が違う時は `-StrataDir <dir>`）
2. 必要なら Hermes 側の診断も併用: `hermes doctor`（存在すれば）、`hermes config check`、`hermes fallback list`。
3. 結果を **FAIL → WARN** の順に整理。各項目に原因と対処を 1 行で付ける。
4. **安全に自動修復できるもの**は実行して良い（permission-policy の範囲内）:
   - KiriDev Skill 未同期 → `powershell -File <KiriDev repo>\scripts\sync-hermes-skills.ps1`
   - LM Studio 停止 → `lms server start`（モデルは `lms load <model>`）
   - ツール欠如 → fallback Skill の tool-missing 経路（ユーザースコープの winget/pip/npm）
   - PATH 重複/欠落 → ユーザー PATH のみ修正（システム PATH は Approval 対象）
   - Strata 停止 → 起動方法を提示（インストール/ダウンロード中なら触らない）
5. 修復後に再実行して差分を示し、`kdlog.py event verify doctor --result ok|fail` で記録。

## Report
```
Doctor: <N> checks / FAIL <a> / WARN <b>
FAIL: <項目> — <原因> → <対処/実施済み>
WARN: ...
自動修復: <実施した内容>
```

## Prohibited
- Strata のインストール/ダウンロード処理を停止・再実行しない。
- 認証情報の値を表示しない（名前のみ）。
