---
name: model-router
description: Local-first で Strata を使い、能力不足時のみ上位モデルへ昇格
version: 1.0.0
metadata:
  hermes:
    tags: [kiridev, core, router, model]
    category: core
  kiridev:
    namespace: kiridev
    category: core
    triggers: [ローカルモデルで品質不足, 同じ失敗が繰り返す, 画像が必要, 大規模設計, モデル切替]
    required_tools: [terminal]
    optional_tools: [delegate_task, vision_analyze]
    dependencies: [hermes]
    conflicts: []
    workflow: see '## Procedure'
    verification: 選んだ route を 1 行で説明でき、昇格先の応答を検証した
    fallback: [Strata → Skill/Context 改善 → Context 縮小 → 別ローカルモデル → 専用モデル → Vision provider → Cloud（Codex / Claude Code / Copilot）]
    risk_level: medium
    source: hand-written
---

# model-router

基本思想: **Local-first, Cloud-escalation**。Cloud へ無条件に投げない。設定の詳細は KiriDev repo `docs/model-routing.md`。

## Routes（config: `%LOCALAPPDATA%\hermes\config.yaml`）
| route | 指定 | 用途 |
|---|---|---|
| local-strata | `--provider strata -m strata`（providers.strata, http://127.0.0.1:8080/v1） | 既定の作業モデル |
| local-lmstudio | `--provider lmstudio -m qwen3.8-9b-distill`（:1234） | 予備ローカル / 軽作業 |
| cloud-codex | bundled skill `codex`（`codex exec ...`）または provider `openai-codex` | 難しい実装・大規模リファクタ |
| cloud-claude-code | bundled skill `claude-code`（`claude -p ...`、CLI 未導入なら不可） | 設計・レビュー |
| cloud-copilot | `--provider copilot`（gh 認証済み） | 汎用 Cloud fallback |
| vision | `vision_analyze`（auxiliary.vision の provider） | 画像・スクリーンショット・図 |

provider 障害（接続不可・5xx・429・401）は Hermes の `fallback_providers` が turn 単位で自動切替する（Skill の判断不要）。

## Procedure（品質・能力不足時の昇格判断）
1. **Local で十分か**: 通常のコード編集・調査・ドキュメントは Local で処理。
2. **昇格前に安い手を試す**: 適切な Skill をロード → 不要 Context を削る（/compress、関連ファイルだけ読む）→ タスク分割。
3. **昇格条件**（どれか）: 同じ失敗が 3 回 / ビルド・テストが 2 回連続で同じ原因不明エラー / 画像理解が必要でローカルが非対応 /
   大規模な設計判断で根拠が弱い / ユーザーが明示。
4. **昇格の実行**（Agent から呼べる順）:
   - 部分タスクを Cloud に一発委譲: `hermes chat -q "<自己完結した指示>" --provider copilot -m <model> --oneshot`（terminal）
   - コーディング委譲: `codex exec "<指示>"`（bundled `codex` Skill の手順）
   - 画像: `vision_analyze`
   - 会話全体を切替えるのはユーザー操作 `/model <provider>:<model>` として提案する。
5. 昇格結果は必ず Local 側で検証（build/test/diff）してから採用。route と理由を `kdlog.py event route` に記録。

## Prohibited
- Secret / 認証情報を含むファイル内容を Cloud に送らない（permission-policy）。
- 認証が無い provider を繰り返し叩かない（authentication-required → 別 route）。
