---
name: software-installation
description: インストーラ(msi/exe/msix)の安全な導入とアンインストール
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
    - インストール
    - msi
    - setup.exe
    - アンインストール
    required_tools:
    - terminal
    optional_tools:
    - web_extract
    dependencies:
    - winget
    - msiexec
    conflicts: []
    workflow: see '## Procedure'
    verification: Get-AuthenticodeSignature が Valid で、アプリが --version を返す
    fallback:
    - package-management の winget/choco に切替
    - ポータブル版 zip を使う
    - Windows Sandbox / Docker で事前検証
    risk_level: high
    related:
    - package-management
    - archive-compression
    - supply-chain-review
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# software-installation

インストーラ(msi/exe/msix)の安全な導入とアンインストール

## When to Use
Trigger: インストール, msi, setup.exe, アンインストール

## Tools
- required: terminal
- optional: web_extract
- dependencies: winget, msiexec（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. 提供元の公式 URL を確認し Get-FileHash でハッシュを照合する
2. Get-AuthenticodeSignature <file> で署名を確認する
3. msi は msiexec /i <f> /qn /l*v install.log、exe は /? でサイレントオプションを確認する
4. 導入後に Get-Command とレジストリ Uninstall キーで登録を確認する
5. アンインストールは winget uninstall --id <id> を使う

## Verification
Get-AuthenticodeSignature が Valid で、アプリが --version を返す

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. package-management の winget/choco に切替
2. ポータブル版 zip を使う
3. Windows Sandbox / Docker で事前検証

## Related
package-management, archive-compression, supply-chain-review

## Prohibited
- 署名なし/ハッシュ不一致のバイナリを実行しない
- 承認なしでドライバ・システムコンポーネントを導入しない
- 購入・課金を伴う導入を承認なしで行わない
- Approval 対象（permission-policy 参照）は実行前に確認する。
