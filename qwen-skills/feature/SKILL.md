---
name: feature
description: '新規機能を「要件 → 設計 → タスク分解 → 実装」の順で進める入口コマンド。Spec Kit の speckit-require で spec.md/plan.md/tasks.md を作り、ユーザー確認後に tasks.md どおり実装する。--auto で speckit-autonomous（質問なしで最後まで）に切り替える。Invoke with /feature <機能説明|SPEC-ID> [--auto]。'
argument-hint: "<機能説明 | SPEC-ID> [--auto]"
disable-model-invocation: true
license: MIT
metadata:
  tags: "Spec, Design, TaskBreakdown, SpecKit"
  category: "productivity"
---

# feature

対象: **$ARGUMENTS**

引数が空なら、何を作るかを1行で質問して止まる。

## 前提チェック

1. リポジトリに `.specify/` があるか確認する。なければ Spec Kit が未導入と伝え、`speckit-require` スキルの導入手順に従って導入してよいか確認する（勝手に導入しない）。
2. 引数が `SPEC-` で始まる場合は既存仕様への追記・続きとして扱う。

## モード A: 通常（`--auto` なし）

1. **要件・設計・タスク分解**: `speckit-require` スキルの手順を最後まで実行し、`spec.md → plan.md → tasks.md` を生成・更新する。
   - clarify では要件の曖昧点だけを質問する（最大5問、選択肢つき）。
   - plan.md には設計（構成・データモデル・インタフェース・採用技術と理由）を必ず含める。
   - tasks.md は1タスク1つの検証可能な作業に分解し、テストタスクを含める。
2. **確認ゲート**: 実装前に以下を短く提示し、「実装開始してよいか」を1回だけ確認する。
   - 要件の要約（3行以内）
   - 設計の要点（5項目以内）
   - タスク数と最初の3タスク、規模の見積もり（時間で）
3. **実装**: 承認されたら `speckit-autonomous` スキルの「Phase C: 実装フェーズ」の手順で tasks.md を上から消化する。
   - 各タスクはテスト/ビルドで検証してから tasks.md のチェックを付ける。
   - 仕様の範囲内の細かい判断は自分で決め、報告に記録する。

## モード B: `--auto`

`speckit-autonomous` スキルの手順をそのまま実行する（clarify も確認ゲートも質問しない。曖昧点は既定値を決めて spec.md に記録）。

## 共通の制約

- ブランチの作成・切替はしない（Spec Kit スクリプトが作る worktree のみ使用）。
- 破壊的・外部向け操作（force push、公開、PR/Issue 作成、送信）は実行前に確認する。
- 出力は日本語、SPEC ID は `SPEC-[UUID8桁]` 形式。
- テストを弱める・期待値をハードコードする・検証を飛ばすことで完了扱いにしない。

## 終了時の報告

1行目に「何が動くようになったか」と試し方を書き、続けて以下を簡潔に。

1. **完了タスク** — tasks.md の番号と `file:line`
2. **残タスク** — 次の一手つき
3. **自分で決めた判断 / 保留理由**
