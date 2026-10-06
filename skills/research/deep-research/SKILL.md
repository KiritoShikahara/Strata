---
name: deep-research
description: 多段階の調査で網羅的なレポートを作る
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - research
    category: research
  kiridev:
    namespace: kiridev
    category: research
    triggers:
    - 徹底調査
    - deep research
    - 詳細レポート
    - 比較調査
    required_tools:
    - web_search
    - web_extract
    - delegate_task
    optional_tools:
    - todo
    - write_file
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: レポートの全論点に出典 URL があり、未解決点が明示されている
    fallback:
    - 情報不足の論点は別言語・別キーワードで再検索
    - コンテキスト溢れ時は delegate_task で論点単位に分割
    - web ツール不通は browser_* 経由、さらにダメなら既知情報と明記して暫定回答
    risk_level: low
    related:
    - web-research
    - source-verification
    - citation-management
    - context-builder
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# deep-research

多段階の調査で網羅的なレポートを作る

## When to Use
Trigger: 徹底調査, deep research, 詳細レポート, 比較調査

## Tools
- required: web_search, web_extract, delegate_task
- optional: todo, write_file
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. todo に調査論点を列挙し、論点ごとに検索クエリを 2 個以上用意する
2. 論点ごとに web_search -> web_extract で一次情報を収集し、メモを research\notes.md に追記
3. 論点間で矛盾する情報を洗い出し source-verification で再確認する
4. 結論・根拠・未解決点・信頼度を分けた Markdown レポートを write_file で保存

## Verification
レポートの全論点に出典 URL があり、未解決点が明示されている

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. 情報不足の論点は別言語・別キーワードで再検索
2. コンテキスト溢れ時は delegate_task で論点単位に分割
3. web ツール不通は browser_* 経由、さらにダメなら既知情報と明記して暫定回答

## Related
web-research, source-verification, citation-management, context-builder

## Prohibited
- 出典不明の情報を事実として断定しない
- 調査結果の外部送信・公開を承認なしで行わない
- Approval 対象（permission-policy 参照）は実行前に確認する。
