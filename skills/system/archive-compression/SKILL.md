---
name: archive-compression
description: zip/7z/tar の圧縮・展開
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - system
    category: system
  kiridev:
    namespace: kiridev
    category: system
    triggers:
    - zip
    - 7z
    - tar
    - 圧縮
    - 解凍
    required_tools:
    - terminal
    optional_tools: []
    dependencies:
    - tar
    - 7z
    conflicts: []
    workflow: see '## Procedure'
    verification: 展開後のファイル数/ハッシュが一覧と一致、7z t <archive> が OK
    fallback:
    - 'Expand-Archive 失敗: tar -xf に切替'
    - '7z 不在: winget install 7zip.7zip'
    - '大きな zip: .NET System.IO.Compression.ZipFile'
    - WSL の unzip/tar
    risk_level: low
    related:
    - filesystem
    - universal-document-ingestion
    - security-review
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# archive-compression

zip/7z/tar の圧縮・展開

## When to Use
Trigger: zip, 7z, tar, 圧縮, 解凍

## Tools
- required: terminal
- optional: -
- dependencies: tar, 7z（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 展開先は新規の空ディレクトリを作る(mkdir)
2. tar -tf <archive> / 7z l <archive> で内容と ../ 絶対パスを事前確認する
3. Expand-Archive -Path <zip> -DestinationPath <dir> または 7z x <a> -o<dir> で展開する
4. 圧縮は Compress-Archive -Path <src>\* -DestinationPath <zip> / 7z a -mx=5 を使う
5. 展開後にファイル数と Get-FileHash を確認する

## Verification
展開後のファイル数/ハッシュが一覧と一致、7z t <archive> が OK

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. Expand-Archive 失敗: tar -xf に切替
2. 7z 不在: winget install 7zip.7zip
3. 大きな zip: .NET System.IO.Compression.ZipFile
4. WSL の unzip/tar

## Related
filesystem, universal-document-ingestion, security-review

## Prohibited
- 信頼できないアーカイブを作業ディレクトリ内で展開・実行しない
- 既存フォルダへ上書き展開しない
- パスワード付きの総当たりをしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
