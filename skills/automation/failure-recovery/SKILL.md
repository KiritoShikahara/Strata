---
name: failure-recovery
description: 失敗の原因分類と代替経路での復旧
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - automation
    category: automation
  kiridev:
    namespace: kiridev
    category: automation
    triggers:
    - 失敗
    - エラー復旧
    - リトライ
    - 詰まった
    required_tools:
    - terminal
    optional_tools:
    - read_file
    - search_files
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 復旧後に元の目的コマンドが成功、または試行履歴付きで報告されている
    fallback:
    - 権限不足 → 昇格要否をユーザーに確認
    - ネットワーク → オフライン代替/キャッシュ
    - doctor で環境診断
    risk_level: low
    related:
    - fallback
    - debugging
    - rollback
    - doctor
    - checkpoint
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# failure-recovery

失敗の原因分類と代替経路での復旧

## When to Use
Trigger: 失敗, エラー復旧, リトライ, 詰まった

## Tools
- required: terminal
- optional: read_file, search_files
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. エラー全文・exit code を確認し分類（tool-missing/権限/パス/ネットワーク/構文/仕様）
2. 同一コマンドの無策再試行は避け、原因に応じて修正（パス引用・実行ポリシー・エンコーディング UTF-8）
3. fallback の順に代替経路へ（導入→portable→Docker/WSL→別ツール）
4. 変更途中の失敗は checkpoint/rollback で一貫状態へ戻す
5. 3経路で失敗したら状況・試行・残案を報告

## Verification
復旧後に元の目的コマンドが成功、または試行履歴付きで報告されている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 権限不足 → 昇格要否をユーザーに確認
2. ネットワーク → オフライン代替/キャッシュ
3. doctor で環境診断

## Related
fallback, debugging, rollback, doctor, checkpoint

## Prohibited
- 「できない」だけで終えない
- 権限回避のためセキュリティ設定を無断変更しない
- テスト弱体化で回避しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
