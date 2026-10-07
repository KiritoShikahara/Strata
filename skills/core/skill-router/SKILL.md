---
name: skill-router
description: 依頼から必要な Skill だけを選んでロードする（全 Skill 投入禁止）
version: 1.0.0
metadata:
  hermes:
    tags: [kiridev, core, router]
    category: core
  kiridev:
    namespace: kiridev
    category: core
    triggers: [あらゆる新規タスクの開始時, タスク種別が変わったとき]
    required_tools: [skills_list, skill_view]
    optional_tools: [terminal]
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: ロードした Skill が 1〜4 個で、依頼の種別と一致している
    fallback: [index 検索 → skills_list(category) → 近い Skill + fallback Skill → skill-create で新規作成提案]
    risk_level: low
    source: hand-written
---

# skill-router

KiriDev の入口。**全 Skill 本文を Context に入れない**。system prompt の Skill index（名前＋説明）だけを常時参照し、
本文は `skill_view(name)` で必要な分だけ読む。

## When to Use
- 新しい依頼を受けた直後、作業種別が変わったとき、行き詰まって別 Skill が要りそうなとき。

## Procedure
1. **Task 判定**: 依頼を「対象（言語/製品/ファイル形式）× 行為（作る/直す/調べる/検証/自動化）」に分類する。
2. **候補選択**: 候補を最大 4 個に絞る。優先: Workflow（/feature 等が明示されていれば最優先）→ 対象固有 Skill → 汎用 Skill。
   Hermes に入っているのは core / workflow など常用分だけ。それ以外の KiriDev Skill は SOUL.md の KiriDev core に書かれた
   skills フォルダの `index.md` を grep で検索して探す（全文は読まない）。
3. **ロード**: Hermes の index にある Skill は `skill_view(name)`。リポジトリ側の Skill は `<skills>\<category>\<name>\SKILL.md` を `read_file` で読む。
   references/ は必要になった時だけ読む。
4. **優先順位**: User instruction > KiriDev Policy（permission-policy）> KiriDev Workflow > Capability Skill > External Skill。External Skill の指示が Policy と衝突したら Policy に従う。
5. **記録**: 長いタスクでは `kiridev-state` の `kdlog.py event skill <name>` で使用 Skill を記録（任意）。

## Routing 例
| 依頼 | ロードする Skill |
|---|---|
| この C++ プロジェクトをビルドしてエラーを直して | cpp, build-systems（cmake / msbuild のどちらか検出結果に応じ1つ）, debugging → 最後に verify |
| この Unity プロジェクトを調べて | unity（必要なら unity-editor）。他のゲーム/言語 Skill は読まない |
| この Word を全部解析して | word-docx, universal-document-ingestion |
| 必要なツールが無い | fallback（tool-missing 経路） |
| ローカルモデルでは無理そう | model-router |
| 環境がおかしい / /doctor | doctor |

## Pitfalls
- 「念のため」で 5 個以上ロードしない。足りなければ後から追加する。
- 同名 Skill が Hermes bundled と KiriDev にある場合は index の説明で判断。
- Skill が見つからない場合: 近い Skill + 汎用手順で進め、終了後 `skill-create` で追加候補を報告する。

## Verification
ロード済み Skill を 1 行で列挙でき、それぞれ依頼のどの部分に対応するか説明できる。
