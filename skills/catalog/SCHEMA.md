# Capability skill catalog schema

`skills/catalog/<category>.yaml` は Capability Skill（Core / Workflow 以外の能力 Skill）の
正本データ。`scripts/kiridev_skills.py build` が各エントリから
`skills/<category>/<name>/SKILL.md` を生成する（手書きの SKILL.md が既にある場合は上書きしない）。

```yaml
category: system            # skills/<category>/ のディレクトリ名
defaults:                   # 全エントリ共通の既定値（エントリ側で上書き可）
  tools: [terminal]
  fallback: [tool-missing: winget/pip/npm で導入 → 代替ツール]
  risk: low
skills:
  - name: powershell        # kebab-case。Hermes の slash command 名になる
    d: PowerShell 5.1/7 でのスクリプト実行と自動化   # 説明。日本語 60 文字以内
    tr: [PowerShell, ps1, Get-, Set-]                # Trigger（キーワード / 依頼例）
    tools: [terminal, read_file]                     # required_tools（Hermes tool 名）
    opt: [execute_code]                              # optional_tools
    deps: [pwsh]                                     # 外部コマンド / パッケージ（無ければ []）
    steps:                                           # 標準 Workflow（3〜6 手順、具体的に）
      - "..."
    verify: "..."                                    # 完了確認方法（1 行、具体的なコマンド等）
    fb:                                              # Failure 時の代替経路（順序つき）
      - "..."
    rel: [cmd, filesystem]                           # 連携 Skill
    no: ["..."]                                      # 禁止事項
    risk: low|medium|high
```

Hermes tool 名: terminal, process, read_file, write_file, patch, search_files, execute_code,
web_search, web_extract, browser_navigate, browser_snapshot, browser_click, browser_type,
browser_vision, vision_analyze, video_analyze, image_generate, text_to_speech, delegate_task,
todo, memory, session_search, skill_view, skills_list, skill_manage, cronjob, clarify, computer_use.

ルール:
- 一般論を書かない。Windows 11 + PowerShell 前提の具体的コマンド・手順を書く。
- 失敗時は「できない」で終えず fb の順に代替経路を試す（docs/fallback.md の Failure Class）。
- Approval 対象（大規模不可逆削除・Secret 外部送信・公開・外部送信・課金・重要システム設定）は no に明記。
