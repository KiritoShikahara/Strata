# KiriDev Hermes + Strata Skill導入指示書

## 目的

Windows 11 Pro環境上に構築する **Hermes + StrataベースのKiriDev AI開発環境**へ、必要なSkill・Workflow・Router・Fallback・Verification機構を実際に導入する。

今回の作業は「設計案を出す」ことが目的ではない。

**現在の環境を調査し、必要なファイル作成・設定変更・依存関係導入・Skill導入・動作確認まで実施すること。**

---

# 1. 基本構成

KiriDevでは役割を以下のように分離する。

## Hermes

HermesをAgent / Harnessとして使用する。

担当:

- Skill管理
- Tool呼び出し
- Workflow実行
- Task管理
- Model Routing
- Provider Routing
- Permission Policy
- Context構築
- Fallback
- Verification
- Automation

Skillは原則として **Hermes側に実装する**。

---

## Strata

StrataはLocal LLMのInference Backendとして使用する。

Strata自体へ大量のSkill定義を直接埋め込まない。

HermesからOpenAI互換等のAPI経由でStrataを利用する。

想定Local Model:

- Qwen系モデル
- IQ3_XXS構成を主候補

---

# 2. 最重要設計原則

## Contextを肥大化させない

全Skill本文を常時Contextへ投入してはいけない。

常時ロードするのは原則として以下のみ。

- Skill Router
- Tool Router
- Model Router
- Permission Policy
- Core Workflow
- Skill Index

それ以外は、

> Task判定 → 必要Skill選択 → 必要Skillだけロード

とする。

---

# 3. Permission Policy

KiriDevは高い自律性を重視する。

基本方針:

**Default Allow**

通常操作では毎回ユーザー確認を要求しない。

通常許可対象:

- ファイル読み書き
- プロジェクト内編集
- Terminal
- PowerShell
- CMD
- Git
- Build
- Test
- Package installation
- Docker
- WSL
- Browser
- Web access
- HTTP API
- ローカルサービス起動
- ローカルAI操作
- 開発ツール操作
- 一時ファイル生成
- ログ取得
- Dependency修復

以下のみApproval対象とする。

- 大規模かつ不可逆な削除
- Credential / Secretの外部送信
- Credential変更
- 重要なWindowsシステム設定変更
- Public公開
- 外部へのメッセージ送信
- 金銭・購入・契約操作
- 明確に高リスクな管理者操作

些細な操作で確認を連発しないこと。

---

# 4. Skill System

Skillは最低限以下のmetadataを持つこと。

```yaml
name:
namespace:
category:
version:
description:
triggers:
required_tools:
optional_tools:
dependencies:
conflicts:
workflow:
verification:
fallback:
risk_level:
```

必要であれば追加metadataを設計してよい。

ただし過剰設計は避ける。

---

# 5. Skill分類

以下の分類を標準とする。

```text
skills/
├─ core/
├─ system/
├─ development/
├─ languages/
├─ cpp-windows/
├─ game-development/
├─ web-backend/
├─ research/
├─ ai/
├─ documents/
├─ data/
├─ multimodal/
├─ creative/
├─ quality/
├─ security/
├─ automation/
├─ workflow/
└─ external/
```

Hermes既存仕様に適した標準ディレクトリが存在する場合は、それを優先してよい。

ただし分類概念は維持すること。

---

# 6. Core / Router Skills

最優先で実装する。

- skill-router
- tool-router
- model-router
- provider-routing
- fallback-model-routing
- permission-policy
- context-builder

## Skill Router

ユーザー要求から必要Skillのみを選択する。

すべてのSkillをContextにロードしてはいけない。

---

## Tool Router

Taskに必要なToolだけをLLMへ公開する。

Permissionが広いことと、毎回全ToolをContextへ公開することを混同しない。

---

## Model Router

最低限以下を扱える構造にする。

- Local Strata
- Claude Code
- Codex
- 将来追加されるProvider
- Vision対応Provider

基本思想:

**Local-first, Cloud-escalation**

---

# 7. PC / System Skills

以下を実装する。

- windows-control
- powershell
- cmd
- filesystem
- process-management
- service-management
- registry
- environment-variables
- package-management
- software-installation
- archive-compression
- network-diagnostics
- http-api
- ssh
- remote-execution
- remote-desktop-assist
- docker
- docker-compose
- wsl-linux
- system-monitoring
- hardware-diagnostics
- gpu-nvidia
- storage-management
- backup-restore
- permissions-acl
- scheduled-tasks
- logs-event-viewer

---

# 8. Development Skills

以下を実装する。

- software-architecture
- system-design
- requirements-analysis
- refactoring
- debugging
- testing
- tdd
- profiling-performance
- benchmarking
- dependency-management
- build-systems
- package-release

---

# 9. Language Skills

以下を実装する。

- cpp
- c
- csharp
- python
- javascript
- typescript
- sql
- powershell-scripting
- bash

---

# 10. C++ / Windows Skills

以下を実装する。

- cmake
- msbuild
- msvc
- win32
- directx11
- directx12
- graphics-debugging
- memory-performance
- concurrency
- ecs
- physics-integration

---

# 11. Game Development Skills

以下を実装する。

- unity
- unity-editor
- unity-cli
- unity-profiling
- unreal-engine
- unreal-cpp
- unreal-blueprint
- unreal-build-tool
- gameplay-systems
- game-ai
- game-networking
- game-design
- game-debugging
- shader-hlsl
- asset-pipeline

Unity / Unreal Editor自体はWindows Nativeで扱う。

Docker内へ無理にEditorを入れない。

---

# 12. Web / Backend Skills

以下を実装する。

- frontend
- html-css
- react
- nodejs
- backend-api
- database-design
- mysql
- postgresql
- redis
- nginx
- websocket
- auth
- api-design

---

# 13. Web / Research Skills

以下を実装する。

- web-research
- deep-research
- source-verification
- primary-source-first
- browser-automation
- agent-browser
- technical-docs-research
- github-research
- x-search
- community-research
- competitive-research
- product-research
- market-research
- fact-checking
- citation-management
- web-archiving
- site-navigation
- form-interaction
- download-management

Researchでは可能な限りPrimary Sourceを優先する。

---

# 14. AI / Local AI Skills

以下を実装する。

- strata
- local-llm
- llama-cpp
- model-selection
- quantization
- gpu-offload
- context-engineering
- prompt-engineering
- context-compression
- rag
- embedding-search
- model-evaluation
- agent-evaluation
- tool-use-evaluation
- benchmark-suite
- mcp
- agent-design
- multi-model-routing
- provider-routing
- skill-authoring
- skill-evaluation
- self-improving
- memory-design
- subagent-design
- vision-routing
- fallback-model-routing

---

# 15. Office Skills

以下を実装する。

- word-docx
- powerpoint-pptx
- excel-xlsx
- office-ooxml-inspection
- office-native-automation
- office-rendering
- embedded-media-extraction
- smartart-analysis
- chart-analysis
- speaker-notes-analysis

---

# 16. Document Skills

以下を実装する。

- pdf
- document-authoring
- document-editing
- document-comparison
- document-summarization
- document-structure-analysis
- table-reconstruction
- ocr-fallback
- universal-document-ingestion

---

# 17. Office / Document Fallback

「画像が入っているから読めない」等でユーザーへ作業を投げ返さない。

以下のFallback Chainを実装する。

```text
Native parser
↓
OOXML direct inspection
↓
Embedded media extraction
↓
Native Office rendering
↓
PDF/Image rendering
↓
Vision analysis
↓
OCR
↓
Alternate parser/converter
↓
Verification
```

OCRは第一選択にしない。

Officeファイルについては必要に応じてZIPとして直接解析し、

- media
- relationships
- drawings
- charts
- SmartArt

などを取得する。

---

# 18. Data Skills

以下を実装する。

- spreadsheet
- csv-tsv
- json
- yaml
- xml
- sqlite
- data-cleaning
- data-analysis
- statistics
- charting
- report-generation

---

# 19. Multimodal Skills

以下を実装する。

- vision
- image-analysis
- image-generation
- image-editing
- diagram-analysis
- screenshot-analysis
- ui-ux-analysis
- ui-ux-generation
- audio-analysis
- speech-to-text
- tts
- music-audio-tools
- video-analysis
- video-frame-extraction

Local ModelがVision非対応の場合はVision ProviderへRoutingする。

---

# 20. Creative Skills

以下を実装する。

- game-design
- level-design
- story-writing
- creative-direction
- asset-generation
- 3d-pipeline
- blender-assist

---

# 21. Quality Skills

以下を実装する。

- verification
- verification-before-completion
- spec-compliance
- code-review
- independent-review
- regression-testing
- test-coverage
- static-analysis
- lint-typecheck
- performance-audit
- memory-leak-analysis
- simplicity-yagni
- dead-code-removal
- overengineering-detection
- release-readiness
- artifact-validation

重要:

Agentは、

> 実装したから完了

ではなく、

> 実装 → Build → Test → Verify → Diff確認 → 完了

まで行うこと。

---

# 22. Security Skills

以下を実装する。

- security-review
- dependency-audit
- secret-scan
- permission-audit
- network-security-review
- supply-chain-review

---

# 23. Automation Skills

以下を実装する。

- cron-scheduled-work
- overnight-autonomy
- goal-driven-autonomy
- long-running-task
- checkpoint
- rollback
- handoff
- pickup
- git-worktree
- subagent-delegation
- multi-agent
- workflow-orchestration
- parallel-execution
- task-prioritization
- task-resume
- status-reporting
- failure-recovery
- environment-bootstrap
- self-update
- skill-update

---

# 24. Workflow / Meta Skills

以下を実装する。

- feature
- speckit-require
- speckit-autonomous
- handoff-sonnet
- grill-me
- review
- diagnose
- verify
- retro
- audit
- doctor
- research
- benchmark
- skill-create
- skill-creator
- superpowers
- matt-pocock-skills
- self-improving
- agent-browser
- ponytail

---

# 25. External Skills

以下については、名称だけで適当な実装を作らない。

実在する公開Skill / Repository / Authoritative Sourceを調査する。

対象:

- agent-browser
- grill-me
- skill-creator
- self-improving
- Superpowers
- Matt Pocock Skills
- Ponytail

導入前に、

- 公式Repository
- Original author
- README
- License
- Installation method
- Dependencies
- 更新状況

を確認する。

同名の偽物やForkを誤導入しない。

可能であればExternal Skillは、

```text
external/<provider-or-author>/<skill>
```

のように隔離する。

KiriDevのCore PolicyをExternal Skillが上書きしてはいけない。

優先順位:

```text
User instruction
>
KiriDev Policy
>
KiriDev Workflow
>
Capability Skill
>
External Skill
```

---

# 26. Commands

最低限、以下のCommandをHermesから利用できるようにする。

```text
/handoff
/pull
/priorities
/pickup
/overnight <duration>
/overnight-goal <goal>
/feature <description>
/feature --auto <description>

/speckit-require <description>
/speckit-require SPEC-xxxxxxxx <addition>
/speckit-autonomous <description>
/speckit-update

/handoff-sonnet <description>

/verify
/review
/diagnose
/retro
/checkpoint
/rollback
/doctor
/worktree
/research
/audit
/benchmark
/skill-create

/commit
/push
/compus

/i-have-adhd
```

---

# 27. /feature

標準開発Entry Point。

```text
User Request
↓
Requirements
↓
Design
↓
Task decomposition
↓
spec.md
plan.md
tasks.md
↓
ONE confirmation
↓
Implementation
↓
Build
↓
Test
↓
Verification
↓
Report
```

`--auto`指定時は確認なし。

---

# 28. /speckit-require

以下のみ行う。

```text
Requirements
↓
Design
↓
Task breakdown
↓
spec.md
plan.md
tasks.md
```

実装はしない。

---

# 29. /speckit-autonomous

```text
Requirements
↓
Design
↓
Tasks
↓
Implementation
↓
Build
↓
Test
↓
Verification
```

質問を極力行わず自律実行する。

---

# 30. /overnight

指定された時間、自律作業するためのWorkflow。

必須機能:

- Checkpoint
- Crash recovery
- Progress persistence
- Worktree / Branch isolation when useful
- Repeated verification
- Final report

途中で一時的エラーが出ても即停止しない。

---

# 31. /handoff

別PCや別Sessionへ作業を引き継ぐ。

最低限記録:

- Goal
- Current status
- Completed tasks
- Remaining tasks
- Important files
- Decisions
- Current branch
- Relevant commits
- Build state
- Test state
- Known problems
- Next recommended action

必要に応じてCommit / Pushまで行う。

---

# 32. /pickup

既存Handoff / Checkpoint / Git状態 / Project stateを読み取り、

「前回何をしていたのか」

を復元して継続する。

ユーザーに毎回説明を求めない。

---

# 33. /diagnose

以下の順で行う。

```text
Reproduce
↓
Collect evidence
↓
Generate hypotheses
↓
Measure
↓
Identify root cause
↓
Fix
↓
Regression test
↓
Verify
```

推測だけで修正しない。

---

# 34. /verify

最低限以下を確認する。

- Build
- Tests
- Lint
- Type check
- Runtime
- Git diff
- Spec compliance
- Regression
- Artifact validity

Taskに存在しない項目はSkip可能。

---

# 35. /doctor

KiriDev環境そのものを診断する。

確認対象:

- Hermes
- Strata
- Local Model
- Model API
- Python
- Node
- Git
- PowerShell
- Docker
- WSL
- Network
- Required ports
- Skill registry
- Tool registry
- Provider connections
- Permissions
- Broken dependencies
- PATH
- Environment variables

問題が安全に自動修復可能なら修復する。

---

# 36. General Fallback Engine

「できない」で即終了しない。

基本フロー:

```text
Task
↓
Primary Route
↓
Execute
↓
Verify
↓
Failure
↓
Classify failure
↓
Alternative Route
↓
Retry
↓
Verify
↓
Escalate only when necessary
```

Failure Class:

- tool-missing
- tool-crash
- unsupported-format
- permission-denied
- dependency-missing
- network-failure
- authentication-required
- parser-incomplete
- vision-required
- model-capability-gap
- context-overflow
- build-failure
- test-failure
- environment-drift
- workspace-corruption
- remote-node-unavailable
- rate-limit
- unknown

---

# 37. Tool Missing Fallback

```text
Search installed tools
↓
Check PATH
↓
Package manager
↓
Automatic install
↓
Portable install
↓
Docker alternative
↓
WSL alternative
↓
Alternative tool
↓
User intervention
```

High-riskでなければ可能な範囲で自動解決する。

---

# 38. Context Overflow Fallback

```text
Relevant file retrieval
↓
Conversation/task summarization
↓
Retrieval context
↓
Task split
↓
Subagent
↓
Persist state
↓
Continue
```

---

# 39. Model Fallback

Local Modelで品質不足または能力不足の場合:

```text
Strata
↓
Better Skill / Context
↓
Context reduction
↓
Alternative local model
↓
Specialized model
↓
Vision provider
↓
Claude Code / Codex等Cloud
```

Cloudへ無条件に投げない。

Localで十分なTaskはLocalで処理する。

---

# 40. Skill Creation

各Skillは巨大な一般論ドキュメントにしない。

以下を明確にする。

- このSkillが必要になる条件
- 使用可能なTool
- 標準Workflow
- Verification方法
- Failure時Fallback
- 他Skillとの連携
- 禁止事項

重複Skillは共通化する。

---

# 41. Self Improvement

Task終了後、失敗・回復・成功Patternから、

- Skill改善
- Trigger改善
- Workflow改善
- Tool routing改善
- Model routing改善
- Fallback改善

の候補を生成可能にする。

ただしCore PolicyをAIが勝手に破壊的変更してはいけない。

---

# 42. Logging / State

最低限以下を記録可能にする。

- Task execution
- Tool execution
- Model route
- Fallback activation
- Failure reason
- Verification result
- Skill usage
- Checkpoint
- Benchmark

初期実装ではSQLiteでよい。

大規模DBを最初から導入しない。

---

# 43. Canonical Configuration

可能な限り、

- Skill definitions
- Workflow
- Policies
- Node configuration
- Model configuration

はGit管理可能な、

- Markdown
- YAML
- JSON

等の人間可読形式にする。

Runtime StateだけSQLite等へ保存する。

---

# 44. Installation Policy

必要Dependencyは安全であれば自動導入してよい。

ただし以下を行うこと。

1. 既存環境確認
2. 既存設定Backup
3. Version確認
4. Official/Trusted source確認
5. Install
6. PATH等設定
7. 起動確認
8. Integration確認
9. Test
10. Result記録

既存環境を理由なく壊さない。

---

# 45. 実装順序

以下の順で作業する。

## Phase 1 — Discovery

現在のHermes / Strata / OS / Directory / Config / Skill仕様を調査。

実際のHermes仕様を確認し、本指示書をHermesの実装方式へMappingする。

---

## Phase 2 — Core

実装:

- Skill Registry
- Skill Router
- Tool Router
- Permission Policy
- Context loader
- Model Router
- Fallback基盤

---

## Phase 3 — Core Skills

最初に重要Skillを実用レベルで作成。

優先:

1. filesystem
2. powershell
3. git
4. debugging
5. testing
6. verification
7. research
8. browser
9. strata
10. model-routing
11. fallback
12. checkpoint
13. handoff
14. pickup
15. doctor

---

## Phase 4 — Development

C++ / C# / Python / JS / Unity / Unreal / Web関連を追加。

---

## Phase 5 — Documents

Office / PDF / Spreadsheet / Universal Document Pipelineを追加。

---

## Phase 6 — Automation

overnight / autonomous / checkpoint / rollback / recoveryを追加。

---

## Phase 7 — External Skills

External SkillをPrimary Sourceから導入。

---

## Phase 8 — Verification

全体を検証。

---

# 46. Acceptance Test

最低限以下が成功すること。

### Test 1

ユーザー:

```text
このC++プロジェクトをビルドしてエラーを直して
```

Expected:

- C++ Skill load
- Build tool detection
- Build
- Error analysis
- Fix
- Rebuild
- Verify

---

### Test 2

```text
このUnityプロジェクトを調べて
```

Expected:

Unity関連Skillのみロード。

全Skillを投入しない。

---

### Test 3

```text
このWordを全部解析して
```

画像を含むDOCXでも、

- Text
- Table
- Embedded image
- Chart

を可能な限り自動取得する。

---

### Test 4

必要Toolが存在しない。

Expected:

自動Discovery / Install / Alternative routeを試行する。

すぐユーザーへ投げ返さない。

---

### Test 5

Local Strataでは明らかに能力不足。

Expected:

Model RouterがEscalationを選択できる。

---

### Test 6

`/doctor`

Expected:

KiriDev/Hermes/Strataの主要環境診断を行い、結果を表示する。

---

### Test 7

`/feature`

Expected:

Requirements → Plan → Tasks → Implementation → Verificationまで進行する。

---

# 47. Completion Criteria

以下を満たすまで完了扱いにしない。

- HermesからSkillを認識できる
- Skill Routerが動作する
- 必要Skillだけをロードできる
- StrataへRequestできる
- Tool execution可能
- Permission Policy有効
- Verification Workflow有効
- Fallbackが最低1経路以上実際に動作する
- Custom Commandsが認識される
- `/doctor`が動作する
- `/verify`が動作する
- Documentationが存在する

---

# 48. Documentation

最終的に以下を作成または更新する。

```text
README.md
docs/
  architecture.md
  skill-system.md
  model-routing.md
  permissions.md
  fallback.md
  commands.md
  installation.md
  troubleshooting.md
```

さらに、

```text
skills/index.*
```

等で全Skill一覧を機械可読・人間可読双方から確認可能にする。

---

# 49. 作業中の原則

ユーザーへ細かい確認を連発しない。

不明点があっても、

- 現環境調査
- Hermes公式仕様
- Primary Source
- Existing code
- Reasonable default

から解決できる場合は自律的に進める。

ただし、

- Credentialが必要
- ユーザーしか知り得ない必須情報
- 不可逆な高リスク変更

の場合のみ確認する。

---

# 50. 最終報告

終了時は長い作業ログではなく以下を報告する。

```text
導入済み
未導入
変更したファイル
追加した依存関係
動作確認結果
失敗している項目
Fallback確認結果
次にやるべきこと
```

また、Git Repository内で作業している場合はGit diffを確認し、不要ファイルやSecretが含まれていないことを確認する。

---

## 最終指示

この指示書を単なる設計資料として処理しないこと。

**現在の環境を調査したうえで、実際にKiriDevのHermes + Strata Skill Systemを構築・導入・設定・検証すること。**

既存Hermes機能で実現できるものは再発明せず利用する。

存在しない機能のみ薄いKiriDev Layerとして追加する。

複雑な独自Frameworkを先に作らない。

**動作する最小構成 → 検証 → Skill追加**

の順番を守ること。

最終目標は、

> ユーザーがHermesへ自然言語で要求するだけで、適切なSkill・Tool・Modelを自動選択し、可能な限り自己解決し、最後まで検証して完了できる環境

を構築することである。
