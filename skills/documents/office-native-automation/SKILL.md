---
name: office-native-automation
description: PowerShell COM で Word/Excel/PowerPoint をネイティブ操作
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - documents
    category: documents
  kiridev:
    namespace: kiridev
    category: documents
    triggers:
    - COM
    - Word.Application
    - Excel.Application
    - ネイティブ Office
    required_tools:
    - terminal
    optional_tools:
    - read_file
    dependencies:
    - Microsoft Office
    conflicts: []
    workflow: see '## Procedure'
    verification: Get-Process WINWORD,EXCEL,POWERPNT で残留プロセスなし、出力ファイルが存在
    fallback:
    - Office 未導入 (Get-Command / レジストリ確認) → LibreOffice soffice --headless
    - COM 起動失敗 → 残留プロセスを確認し再試行、それでも不可なら python-docx 等
    - pandoc による変換
    risk_level: medium
    related:
    - office-rendering
    - word-docx
    - excel-xlsx
    - powerpoint-pptx
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# office-native-automation

PowerShell COM で Word/Excel/PowerPoint をネイティブ操作

## When to Use
Trigger: COM, Word.Application, Excel.Application, ネイティブ Office

## Tools
- required: terminal
- optional: read_file
- dependencies: Microsoft Office（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. $w=New-Object -ComObject Word.Application; $w.Visible=$false; $w.DisplayAlerts=0
2. $d=$w.Documents.Open($path,$false,$true)  # ReadOnly で開く
3. $d.ExportAsFixedFormat($out,17) で PDF、$d.SaveAs2($out,16) で別形式
4. Excel は $x.Workbooks.Open($p,0,$true)、PowerPoint は $pp.Presentations.Open($p,-1,0,0)
5. finally で $d.Close(0); $w.Quit(); [Runtime.InteropServices.Marshal]::ReleaseComObject($w)

## Verification
Get-Process WINWORD,EXCEL,POWERPNT で残留プロセスなし、出力ファイルが存在

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. Office 未導入 (Get-Command / レジストリ確認) → LibreOffice soffice --headless
2. COM 起動失敗 → 残留プロセスを確認し再試行、それでも不可なら python-docx 等
3. pandoc による変換

## Related
office-rendering, word-docx, excel-xlsx, powerpoint-pptx

## Prohibited
- ユーザーが開いているドキュメントを強制終了しない
- マクロ実行 (AutomationSecurity 変更) 禁止
- 元ファイル上書き保存禁止
- Approval 対象（permission-policy 参照）は実行前に確認する。
