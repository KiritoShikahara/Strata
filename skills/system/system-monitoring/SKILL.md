---
name: system-monitoring
description: CPU/メモリ/ディスク/ネットワーク使用状況の監視
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
    - 負荷
    - CPU
    - メモリ
    - 重い
    - パフォーマンス
    required_tools:
    - terminal
    optional_tools:
    - execute_code
    dependencies:
    - powershell
    conflicts: []
    workflow: see '## Procedure'
    verification: 主要指標の数値とボトルネック要因を提示
    fallback:
    - 'Get-Counter 失敗: lodctr /R 後に再試行(承認後)'
    - Get-CimInstance Win32_OperatingSystem 等の WMI 値を使う
    - perfmon / Resource Monitor (resmon) 案内
    - Sysinternals Process Explorer
    risk_level: low
    related:
    - process-management
    - hardware-diagnostics
    - storage-management
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# system-monitoring

CPU/メモリ/ディスク/ネットワーク使用状況の監視

## When to Use
Trigger: 負荷, CPU, メモリ, 重い, パフォーマンス

## Tools
- required: terminal
- optional: execute_code
- dependencies: powershell（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. Get-Counter "\Processor(_Total)\% Processor Time","\Memory\Available MBytes" -SampleInterval 2 -MaxSamples 5
2. Get-Process | Sort WS -Descending | Select -First 10 Name,Id,WS で上位プロセスを確認する
3. Get-PSDrive -PSProvider FileSystem でディスク空きを確認する
4. typeperf / Get-Counter "\PhysicalDisk(*)\Avg. Disk Queue Length" で I/O 待ちを見る
5. 結果をベースラインと比較して要因を報告する

## Verification
主要指標の数値とボトルネック要因を提示

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. Get-Counter 失敗: lodctr /R 後に再試行(承認後)
2. Get-CimInstance Win32_OperatingSystem 等の WMI 値を使う
3. perfmon / Resource Monitor (resmon) 案内
4. Sysinternals Process Explorer

## Related
process-management, hardware-diagnostics, storage-management

## Prohibited
- 監視のためにサービスを停止/再設定しない
- Approval 対象（permission-policy 参照）は実行前に確認する。
