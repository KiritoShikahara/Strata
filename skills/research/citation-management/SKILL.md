---
name: citation-management
description: 出典を一貫した形式で記録・管理する
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
    - 引用
    - 出典管理
    - 参考文献
    - citation
    - bibtex
    required_tools:
    - write_file
    - read_file
    optional_tools:
    - web_extract
    - execute_code
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: 本文の全 [n] が出典リストに存在し、リンクが 200 を返す
    fallback:
    - メタ情報不明は web_extract で title/meta を取得
    - DOI 取得不可は Crossref API(api.crossref.org/works/<doi>)を利用
    - リンク切れは web-archiving の保存 URL に差し替え
    risk_level: low
    related:
    - deep-research
    - web-archiving
    - source-verification
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# citation-management

出典を一貫した形式で記録・管理する

## When to Use
Trigger: 引用, 出典管理, 参考文献, citation, bibtex

## Tools
- required: write_file, read_file
- optional: web_extract, execute_code
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. research\sources.md に 1 出典 1 エントリ(タイトル・著者・URL・公開日・取得日)で記録
2. DOI があれば https://doi.org/<doi> に Accept: application/x-bibtex を付け BibTeX 取得
3. 本文中の主張に [n] 番号を振り、出典リストと対応させる
4. 重複 URL と切れたリンクを Invoke-WebRequest -Method Head で点検する

## Verification
本文の全 [n] が出典リストに存在し、リンクが 200 を返す

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. メタ情報不明は web_extract で title/meta を取得
2. DOI 取得不可は Crossref API(api.crossref.org/works/<doi>)を利用
3. リンク切れは web-archiving の保存 URL に差し替え

## Related
deep-research, web-archiving, source-verification

## Prohibited
- 存在しない文献・URL を作らない
- 引用元を明記せず転載しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
