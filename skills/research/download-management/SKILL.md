---
name: download-management
description: ファイルを安全にダウンロードし検証・整理する
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
    - ダウンロード
    - 取得
    - download
    - ファイル保存
    required_tools:
    - terminal
    optional_tools:
    - browser_navigate
    - read_file
    dependencies: []
    conflicts: []
    workflow: see '## Procedure'
    verification: Get-FileHash の値が公式公開値と一致し、サイズが期待値と合う
    fallback:
    - 'curl.exe 不在は winget install cURL.cURL、または BITS: Start-BitsTransfer'
    - ブラウザ必須のダウンロードは browser-automation を使う
    - ハッシュ不一致は再取得し、それでも不一致なら別ミラー/公式 Releases へ
    risk_level: medium
    related:
    - filesystem
    - powershell
    - web-archiving
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# download-management

ファイルを安全にダウンロードし検証・整理する

## When to Use
Trigger: ダウンロード, 取得, download, ファイル保存

## Tools
- required: terminal
- optional: browser_navigate, read_file
- dependencies: -（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 専用の空ディレクトリを作る: New-Item -ItemType Directory downloads\<name>
2. Invoke-WebRequest -Uri <url> -OutFile downloads\<name>\<file>(大容量は curl.exe -L -C - -O)
3. 公式のハッシュと照合: Get-FileHash -Algorithm SHA256 <file>
4. 圧縮物は別の新規ディレクトリへ展開(Expand-Archive -DestinationPath)し、中身を確認

## Verification
Get-FileHash の値が公式公開値と一致し、サイズが期待値と合う

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. curl.exe 不在は winget install cURL.cURL、または BITS: Start-BitsTransfer
2. ブラウザ必須のダウンロードは browser-automation を使う
3. ハッシュ不一致は再取得し、それでも不一致なら別ミラー/公式 Releases へ

## Related
filesystem, powershell, web-archiving

## Prohibited
- ダウンロード物を未検証で実行しない
- 展開先ディレクトリ内でインタプリタ/ビルドを実行しない
- 大量の既存ファイルの上書き・削除をしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
