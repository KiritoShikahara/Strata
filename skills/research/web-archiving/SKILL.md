---
name: web-archiving
description: Wayback 等で Web ページを保存・過去版を参照する
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
    - アーカイブ
    - Wayback
    - 過去版
    - 保存
    - リンク切れ
    required_tools:
    - web_extract
    - terminal
    optional_tools:
    - browser_navigate
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: Get-FileHash で保存物のハッシュが記録され、archive_url が開ける
    fallback:
    - Wayback 未収録は archive.ph の既存スナップショットを検索
    - wget 不在は winget install JernejSimoncic.Wget、または Invoke-WebRequest
    - ブラウザ印刷 PDF(browser_navigate 後に保存)で代替
    risk_level: low
    related:
    - citation-management
    - fact-checking
    - download-management
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# web-archiving

Wayback 等で Web ページを保存・過去版を参照する

## When to Use
Trigger: アーカイブ, Wayback, 過去版, 保存, リンク切れ

## Tools
- required: web_extract, terminal
- optional: browser_navigate
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 過去版確認: Invoke-RestMethod "https://archive.org/wayback/available?url=<url>"
2. 見つかった archive_url を web_extract で取得する
3. 手元保存は Invoke-WebRequest -Uri <url> -OutFile archive\page.html を空ディレクトリで実行
4. 保存時は URL・取得日時・SHA256(Get-FileHash)を archive\manifest.md に記録

## Verification
Get-FileHash で保存物のハッシュが記録され、archive_url が開ける

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. Wayback 未収録は archive.ph の既存スナップショットを検索
2. wget 不在は winget install JernejSimoncic.Wget、または Invoke-WebRequest
3. ブラウザ印刷 PDF(browser_navigate 後に保存)で代替

## Related
citation-management, fact-checking, download-management

## Prohibited
- Wayback へ非公開・認証付きページを送信しない
- 著作権物を再配布しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
