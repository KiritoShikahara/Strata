---
name: debugging
description: 再現から根本原因特定・回帰テストまでの体系的デバッグ
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - development
    category: development
  kiridev:
    namespace: kiridev
    category: development
    triggers:
    - バグ
    - エラー
    - 例外
    - 動かない
    - クラッシュ
    - debug
    required_tools:
    - terminal
    - read_file
    - search_files
    optional_tools:
    - patch
    - execute_code
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 回帰テストが修正前に失敗・修正後に成功し、元の再現手順で再発しない
    fallback:
    - 再現不能なら環境差（バージョン・PATH・環境変数）を比較する
    - git bisect run で原因コミットを二分探索する
    - ログ不足なら計装を足して再収集。詰まれば research で既知の issue を探す
    risk_level: low
    related:
    - testing
    - verification
    - git
    - profiling-performance
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# debugging

再現から根本原因特定・回帰テストまでの体系的デバッグ

## When to Use
Trigger: バグ, エラー, 例外, 動かない, クラッシュ, debug

## Tools
- required: terminal, read_file, search_files
- optional: patch, execute_code
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 1. Reproduce: 最小の再現手順とコマンドを確定し、失敗を毎回再現できるようにする
2. 2. Collect evidence: エラー全文・スタックトレース・Get-WinEvent やログ・git log -S/git bisect で変更点を集める
3. 3. Hypotheses: 原因仮説を複数立て、各々を反証できる観測方法を決める
4. 4. Measure: ログ追加・デバッガ・プロファイラで実測し仮説を絞る。推測で直さない
5. 5. Root cause→Fix: 根本原因を特定し最小の修正を入れる
6. 6. Regression test→Verify: 失敗する回帰テストを追加し、全テストと元の再現手順で確認する

## Verification
回帰テストが修正前に失敗・修正後に成功し、元の再現手順で再発しない

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 再現不能なら環境差（バージョン・PATH・環境変数）を比較する
2. git bisect run で原因コミットを二分探索する
3. ログ不足なら計装を足して再収集。詰まれば research で既知の issue を探す

## Related
testing, verification, git, profiling-performance

## Prohibited
- 推測だけの修正（根拠なし）をしない
- テストを弱める・スキップして通さない。本番データ/機密ログを外部送信しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
