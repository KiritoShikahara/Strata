---
name: game-networking
description: マルチプレイ同期・ネットコード設計と検証
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - game-development
    category: game-development
  kiridev:
    namespace: kiridev
    category: game-development
    triggers:
    - マルチプレイ
    - ネットワーク
    - レプリケーション
    - Netcode
    - Mirror
    - ラグ補償
    required_tools:
    - terminal
    - read_file
    - write_file
    - patch
    optional_tools:
    - search_files
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 遅延 100–200ms・ロス 5% 下でも状態が収束し不正入力がサーバーで拒否される
    fallback:
    - ネットライブラリ不調時は別実装（Mirror/FishNet 等）で最小例を比較
    - ファイアウォールは受信規則の確認を提案（設定変更は承認後）
    - ローカルループバックで再現して切り分ける
    risk_level: medium
    related:
    - gameplay-systems
    - unity
    - unreal-engine
    - game-debugging
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# game-networking

マルチプレイ同期・ネットコード設計と検証

## When to Use
Trigger: マルチプレイ, ネットワーク, レプリケーション, Netcode, Mirror, ラグ補償

## Tools
- required: terminal, read_file, write_file, patch
- optional: search_files
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. サーバー権威/ P2P/ リッスンサーバーを決め、同期対象状態と頻度を表にする
2. Unity は Netcode for GameObjects/Mirror、Unreal は Replication（UPROPERTY(Replicated)/RPC）を使う
3. クライアント予測・補間・サーバー再調整で遅延を隠蔽する
4. Clumsy / Unreal の Net PktLag/PktLoss で遅延・ロスを再現してテストする
5. ローカル複数クライアント（-nographics ヘッドレスサーバー）で検証する

## Verification
遅延 100–200ms・ロス 5% 下でも状態が収束し不正入力がサーバーで拒否される

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. ネットライブラリ不調時は別実装（Mirror/FishNet 等）で最小例を比較
2. ファイアウォールは受信規則の確認を提案（設定変更は承認後）
3. ローカルループバックで再現して切り分ける

## Related
gameplay-systems, unity, unreal-engine, game-debugging

## Prohibited
- クライアントを信用する設計（権威を持たせる）にしない
- ファイアウォール/ポート開放などの重要設定を承認なしで変更しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
