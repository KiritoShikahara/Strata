---
name: verify
description: Build/Test/Lint/型/実行/差分/仕様準拠を検証して完了判定
version: 1.0.0
metadata:
  hermes:
    tags: [kiridev, workflow, quality]
    category: workflow
  kiridev:
    namespace: kiridev
    category: workflow
    triggers: [/verify, 完了前, 実装した, 動くか確認, テストして]
    required_tools: [terminal, read_file]
    optional_tools: [search_files, delegate_task]
    dependencies: [powershell, git]
    conflicts: []
    workflow: see '## Procedure'
    verification: 各項目が PASS/FAIL/SKIP(理由) で報告されている
    fallback: [verify.ps1 が対象外 → プロジェクトの README/CI 定義からコマンドを抽出して手動実行]
    risk_level: low
    source: hand-written
---

# verify

「実装したから完了」ではなく **実装 → Build → Test → Verify → Diff 確認 → 完了**。

## Procedure
1. 自動検出実行（PowerShell）:
   `powershell -NoProfile -ExecutionPolicy Bypass -File "$env:LOCALAPPDATA\hermes\skills\workflow\verify\scripts\verify.ps1" -Path <project>`
   （npm/pnpm/yarn scripts, pytest/ruff/mypy, CMake+ctest, .sln(dotnet), Cargo を検出。最後に git diff と簡易 secret scan）
2. 検出されない種類（Unity / Unreal / MSBuild C++ 等）は該当 Skill のビルド手順を使う（unity-cli, unreal-build-tool, msbuild）。
   CI 定義（`.github/workflows/*.yml`）があればそのコマンドを優先。
3. 次も確認する（該当しなければ SKIP と理由）:
   - **Runtime**: 実行して期待出力/起動を確認（CLI は実コマンド、サーバは curl でヘルスチェック）
   - **Spec compliance**: 依頼文 / spec.md / tasks.md の要件を 1 つずつ照合
   - **Regression**: 変更前に通っていたテストが通る
   - **Artifact validity**: 生成物（exe, dll, zip, docx, pdf）が存在し開ける・サイズ>0
   - **Git diff**: 意図しないファイル・デバッグ残骸・Secret が含まれない
4. FAIL があれば debugging / diagnose で直して再実行。テストを弱めて通さない。
5. 結果を `kdlog.py event verify <project> --result ok|fail` で記録。

## Report
| 項目 | 結果 | 根拠（コマンド / file:line） | の表 + 最終判定（完了 / 未完了）。
