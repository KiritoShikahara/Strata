---
name: xml
description: XML の解析・XPath 抽出・変換・検証
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - data
    category: data
  kiridev:
    namespace: kiridev
    category: data
    triggers:
    - XML
    - XPath
    - XSLT
    - XSD
    - パース
    - csproj
    - SVG
    required_tools:
    - terminal
    - execute_code
    optional_tools:
    - read_file
    - patch
    dependencies:
    - lxml
    conflicts: []
    workflow: see '## Procedure'
    verification: パースエラー 0、XSD 検証成功、XPath の抽出件数が期待通り
    fallback:
    - pip install lxml、標準 xml.etree.ElementTree で代替
    - xmllint は winget/choco で導入、または lxml で検証
    - 巨大 XML は iterparse でストリーム処理
    risk_level: low
    related:
    - json
    - yaml
    - data-cleaning
    - csv-tsv
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# xml

XML の解析・XPath 抽出・変換・検証

## When to Use
Trigger: XML, XPath, XSLT, XSD, パース, csproj, SVG

## Tools
- required: terminal, execute_code
- optional: read_file, patch
- dependencies: lxml（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 整形式確認: [xml](Get-Content f.xml -Raw) か python -c "import lxml.etree as E;E.parse(\"f.xml\")"
2. 抽出: Select-Xml -Path f.xml -XPath "//item[@id]" または lxml の tree.xpath
3. 名前空間は ns マップを指定して XPath を書く
4. 編集は DOM で行い、Save 時に文字コード宣言（UTF-8）とインデントを保つ
5. XSD があれば xmllint --noout --schema s.xsd f.xml で検証する

## Verification
パースエラー 0、XSD 検証成功、XPath の抽出件数が期待通り

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. pip install lxml、標準 xml.etree.ElementTree で代替
2. xmllint は winget/choco で導入、または lxml で検証
3. 巨大 XML は iterparse でストリーム処理

## Related
json, yaml, data-cleaning, csv-tsv

## Prohibited
- 信頼できない XML を外部実体展開有効で読まない（XXE）
- 元ファイルを直接上書きしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
