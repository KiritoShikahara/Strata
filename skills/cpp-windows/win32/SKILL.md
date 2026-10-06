---
name: win32
description: Win32 API のウィンドウ・メッセージ・エラー処理の実装
version: 1.0.0
metadata:
  hermes:
    tags:
    - kiridev
    - cpp-windows
    category: cpp-windows
  kiridev:
    namespace: kiridev
    category: cpp-windows
    triggers:
    - Win32
    - WinAPI
    - HWND
    - WndProc
    - GetLastError
    required_tools:
    - terminal
    - read_file
    - patch
    optional_tools:
    - web_search
    - search_files
    dependencies:
    - cl
    - cmake
    conflicts: []
    workflow: see '## Procedure'
    verification: ウィンドウが表示・終了でき、ハンドルリークがない (Process Explorer/ Handle 数が安定)
    fallback:
    - 'ヘッダ/リンクエラー: #include <windows.h> と #pragma comment(lib) または target_link_libraries を確認'
    - 'API 不明: web_search で Microsoft Learn を参照'
    - WinUI/Qt/SDL2 で代替
    - Spy++/Window Spy で HWND を検査
    risk_level: low
    related:
    - msvc
    - directx11
    - concurrency
    - debugging
    source: catalog
---
<!-- GENERATED from skills/catalog — edit the catalog, not this file -->

# win32

Win32 API のウィンドウ・メッセージ・エラー処理の実装

## When to Use
Trigger: Win32, WinAPI, HWND, WndProc, GetLastError

## Tools
- required: terminal, read_file, patch
- optional: web_search, search_files
- dependencies: cl, cmake（無ければ `fallback` Skill の tool-missing 経路で導入）

## Procedure
1. WinMain/wWinMain、RegisterClassExW、CreateWindowExW、PeekMessage ループの順で土台を確認する
2. UNICODE/_UNICODE を定義し W 版 API と wchar_t を統一する
3. 戻り値と GetLastError / FormatMessageW で失敗を処理し HANDLE は RAII(unique_handle)で閉じる
4. DPI は SetProcessDpiAwarenessContext(PER_MONITOR_AWARE_V2) とマニフェストで設定する
5. 機能は Microsoft Learn の該当 API の最小 OS 版・ヘッダ・ライブラリを確認して使う

## Verification
ウィンドウが表示・終了でき、ハンドルリークがない (Process Explorer/ Handle 数が安定)

## Fallback（上から順に試す。すぐユーザーへ投げ返さない）
1. ヘッダ/リンクエラー: #include <windows.h> と #pragma comment(lib) または target_link_libraries を確認
2. API 不明: web_search で Microsoft Learn を参照
3. WinUI/Qt/SDL2 で代替
4. Spy++/Window Spy で HWND を検査

## Related
msvc, directx11, concurrency, debugging

## Prohibited
- 未文書化 API・フックを承認なしで使わない
- 他プロセスへのインジェクションをしない
- Approval 対象（permission-policy 参照）は実行前に確認する。
