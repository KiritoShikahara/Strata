---
name: yaml
description: YAML の編集・検証・変換（インデント/型の落とし穴対策）
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
    - YAML
    - yml
    - インデント
    - 設定ファイル
    - CI 設定
    - compose
    required_tools:
    - terminal
    - read_file
    - patch
    optional_tools:
    - execute_code
    dependencies:
    - PyYAML
    - yamllint
    conflicts: []
    workflow: see '## Procedure'
    verification: safe_load が成功し yamllint エラー 0、読み込んだ値の型が意図通り
    fallback:
    - pip install pyyaml yamllint ruamel.yaml で導入
    - docker compose config / kubectl --dry-run など対象ツールの検証を使う
    - yq（winget install MikeFarah.yq）で構造操作
    risk_level: low
    related:
    - json
    - xml
    - data-cleaning
    - build-systems
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# yaml

YAML の編集・検証・変換（インデント/型の落とし穴対策）

## When to Use
Trigger: YAML, yml, インデント, 設定ファイル, CI 設定, compose

## Tools
- required: terminal, read_file, patch
- optional: execute_code
- dependencies: PyYAML, yamllint（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. python -c "import yaml;yaml.safe_load(open(f,encoding=\"utf-8\"))" で構文を確認する
2. yamllint f.yml でインデント（空白 2、タブ禁止）・重複キーを検査する
3. no/yes/on/off や 1.0 など型が変わる値、: # を含む文字列は引用符で囲む
4. 編集は patch で最小差分にし、コメントを保持したい場合は ruamel.yaml を使う
5. 変換が必要なら safe_load → json.dump で JSON 化し差分確認する

## Verification
safe_load が成功し yamllint エラー 0、読み込んだ値の型が意図通り

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. pip install pyyaml yamllint ruamel.yaml で導入
2. docker compose config / kubectl --dry-run など対象ツールの検証を使う
3. yq（winget install MikeFarah.yq）で構造操作

## Related
json, xml, data-cleaning, build-systems

## Prohibited
- yaml.load（unsafe）で信頼できないファイルを読まない
- Secret を含む設定を平文でコミット・送信しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
