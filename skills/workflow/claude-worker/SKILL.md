---
name: claude-worker
description: 実装・調査を Claude Code ultra ワーカーへ委譲（/worker-on 時のみ）
version: 1.0.0
metadata:
  hermes:
    tags: [kiridev, workflow, delegation]
    category: workflow
  kiridev:
    namespace: kiridev
    category: workflow
    triggers: [実装して, 修正して, 調査して, 調べて, web検索, 委譲, ワーカー, claude code]
    required_tools: [terminal]
    optional_tools: [read_file, search_files]
    dependencies: [node, claude, ctx-kit]
    conflicts: []
    workflow: see '## Procedure'
    verification: ワーカーの結果を verify Skill で確認し、git diff を見てから報告している
    fallback: [WORKER_DISABLED(exit 3) / WORKER_UNAVAILABLE(exit 4) → 自分で作業する, ワーカー失敗 → プロンプトを具体化して 1 回だけ再委譲 → だめなら自分で作業]
    risk_level: medium
    source: hand-written
---

# claude-worker

ユーザーが `/worker-on` にしている間、ユーザーが選んだ範囲の作業（既定は実装だけ。調査と Web 検索はあなたが行う）を Claude Code（ultra プロファイル）のワーカーが行う。範囲はあなたには見えないので、毎回 `run` を呼んで `WORKER_DISABLED` かどうかで判断する。あなたは **分解 → 委譲 → 検証 → 報告** だけを行う。

## Procedure
1. 実装・調査・Web 検索の依頼を受けたら、自分でファイルを読み書きしたり Web 検索したりする前に terminal で委譲する（`timeout` は 1800）:
   `node "$env:LOCALAPPDATA\hermes\skills\workflow\claude-worker\scripts\claude-worker.mjs" run --cwd "<project>" "<task>"`
   - 調査だけなら `run --readonly` を付ける（ワーカーはファイルを変更しない）。
   - Web 検索・Web ページの読み取りが必要なら `run --web --readonly` を付ける（ワーカーが WebSearch / WebFetch を使う）。`WORKER_DISABLED` が返らない限り、自分で web_search / web_extract / browser を呼ばない。
2. 出力で分岐する:
   - `WORKER_DISABLED`（exit 3）または `WORKER_UNAVAILABLE`（exit 4）: その種類の作業はワーカーに任せない設定。通常どおり自分で作業する。同じ種類の作業では再度呼ばない（実装 / `--readonly` 調査 / `--web` 調査は別の種類として 1 回ずつ確認してよい）。
   - それ以外: 標準出力がワーカーの最終回答。手順 3 へ。
3. ワーカーの結果を検証する: `git diff` を確認し、skill "verify" を実行する。足りない点があれば、その点だけを新しい `<task>` として再委譲する。
4. 結果を報告する（変更ファイル、検証結果）。

## `<task>` の書き方
ワーカーは **この会話を一切知らず、質問も返せない**。1 回の `<task>` に次をすべて書く:
- 目的（何を、なぜ）
- 対象のパス（ファイル、ディレクトリ）
- 完了条件（通すべきテスト、期待する動作）
- 制約（触ってはいけないもの、コミットしない 等）

大きな依頼は、独立した小さな `<task>` に分けて 1 つずつ委譲する（並列にはしない）。

## 切り替え（ユーザー専用。あなたは実行しない）
`/worker-on` `/worker-off` `/worker-status` `/worker-1` `/worker-2` `/worker-3`（アカウント） `/worker-opus` `/worker-sonnet`（モデル） `/worker-impl` `/worker-code` `/worker-web` `/worker-all`（任せる範囲: 実装だけ（既定） / 実装とファイル調査 / Web 調査だけ / すべて）。
状態は `kiridev-worker.json`（Hermes ホーム）に保存され、再起動後も引き継がれる。状態ファイルを自分で書き換えない。

## Failure
- exit 1 かつ出力にログイン / 認証エラー: ユーザーに「`/worker-status` のアカウントで Claude にログインしてください」と伝え、自分で作業を続ける。
- 同じ `<task>` を 3 回繰り返さない。
