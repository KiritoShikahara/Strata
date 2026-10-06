---
name: multi-model-routing
description: タスク別に複数モデル(ローカル/クラウド)を使い分ける
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - ai
    category: ai
  kiridev:
    namespace: kiridev
    category: ai
    triggers:
    - ルーティング
    - モデル切替
    - auxiliary
    - フォールバックモデル
    required_tools:
    - read_file
    - patch
    optional_tools:
    - terminal
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 各タスク種別で想定モデルが応答し、フォールバックが機能する
    fallback:
    - provider 不通は次順位へ自動/手動切替
    - config 変更後に不調なら直前バックアップから戻す
    - 複数同時ロードで VRAM 不足なら逐次ロード
    risk_level: medium
    related:
    - model-router
    - vision-routing
    - local-llm
    - fallback
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# multi-model-routing

タスク別に複数モデル(ローカル/クラウド)を使い分ける

## When to Use
Trigger: ルーティング, モデル切替, auxiliary, フォールバックモデル

## Tools
- required: read_file, patch
- optional: terminal
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. %LOCALAPPDATA%\hermes\config.yaml の model / auxiliary 設定を確認する
2. 軽量タスク→Strata(:8080)、長文/高難度→クラウド、視覚→vision provider に割当
3. 各 provider の疎通を Invoke-RestMethod <base_url>/models で確認
4. 失敗時の切替順(ローカル→LM Studio→クラウド)を記録する

## Verification
各タスク種別で想定モデルが応答し、フォールバックが機能する

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. provider 不通は次順位へ自動/手動切替
2. config 変更後に不調なら直前バックアップから戻す
3. 複数同時ロードで VRAM 不足なら逐次ロード

## Related
model-router, vision-routing, local-llm, fallback

## Prohibited
- config 変更前にバックアップなしで上書きしない
- 機密データをクラウドモデルへ承認なしで送らない
- API キーを出力しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
