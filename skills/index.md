# KiriDev Skill Index

全 270 Skill。機械可読版: `skills/index.yaml`。再生成: `python scripts/kiridev_skills.py index`。

## ai (24)

| Skill | 説明 | risk | source |
|---|---|---|---|
| `agent-design` | エージェントの役割・ツール・制御フローを設計する | low | catalog |
| `agent-evaluation` | エージェントのタスク完遂率・安全性を評価する | low | catalog |
| `benchmark-suite` | 標準ベンチと自前ベンチで性能を継続計測する | low | catalog |
| `context-compression` | 長い会話・資料を情報を保って圧縮する | low | catalog |
| `context-engineering` | コンテキスト構成・長さ・配置を設計し精度を保つ | low | catalog |
| `embedding-search` | 埋め込みモデルによる意味検索を実装する | low | catalog |
| `gpu-offload` | GPU オフロード層数・VRAM 配分のチューニング | low | catalog |
| `llama-cpp` | llama.cpp(llama-server/llama-cli)の導入と実行 | medium | catalog |
| `local-llm` | ローカル LLM サーバー(Strata/LM Studio)の起動と接続確認 | medium | catalog |
| `mcp` | MCP サーバーの導入・設定・接続確認 | medium | catalog |
| `memory-design` | エージェントの記憶(短期/長期)の保存方針を設計する | low | catalog |
| `model-evaluation` | モデルの品質・速度を再現可能な手順で評価する | low | catalog |
| `model-selection` | 用途・VRAM に合うモデルとサイズを選定する | low | catalog |
| `multi-model-routing` | タスク別に複数モデル(ローカル/クラウド)を使い分ける | medium | catalog |
| `prompt-engineering` | プロンプトを設計・改善し出力品質を安定させる | low | catalog |
| `quantization` | GGUF 量子化の選択・変換・品質比較 | low | catalog |
| `rag` | ドキュメント検索拡張生成(RAG)を構築・運用する | low | catalog |
| `self-improving` | 失敗/回復/成功パターンから Skill・Routing 改善候補を作る | medium | hand-written |
| `skill-authoring` | Hermes Skill(SKILL.md)を設計・作成する | low | catalog |
| `skill-evaluation` | Skill の発火精度と手順の有効性を検証する | low | catalog |
| `strata` | Strata ローカル LLM サーバの起動・疎通・設定・トラブル対応 | medium | hand-written |
| `subagent-design` | サブエージェントへの分割・委任と結果統合を設計する | medium | catalog |
| `tool-use-evaluation` | ツール呼び出しの正確性・引数妥当性を評価する | low | catalog |
| `vision-routing` | 画像入力を視覚対応モデルへ振り分ける | medium | catalog |

## automation (17)

| Skill | 説明 | risk | source |
|---|---|---|---|
| `cron-scheduled-work` | cronjob / hermes cron で定期・予約タスクを設定 | medium | catalog |
| `environment-bootstrap` | 新規 Windows 環境の開発ツールと依存を整備 | medium | catalog |
| `failure-recovery` | 失敗の原因分類と代替経路での復旧 | low | catalog |
| `git-worktree` | git worktree で並行作業用の独立作業ツリーを使う | low | catalog |
| `goal-driven-autonomy` | /goal の達成条件に向けて自律的に計画・実行・検証 | medium | catalog |
| `long-running-task` | 長時間処理をバックグラウンド実行し監視・再開可能にする | low | catalog |
| `multi-agent` | 複数エージェントの役割分担と統合で大規模作業を進める | medium | catalog |
| `overnight-autonomy` | 夜間・不在時に承認不要範囲で自律的に作業を進める | high | catalog |
| `parallel-execution` | 独立タスクを並列実行して時間短縮する | low | catalog |
| `rollback` | 変更を /rollback・/snapshot・git で安全に巻き戻す | high | catalog |
| `self-update` | hermes update で Hermes 本体を安全に更新 | medium | catalog |
| `skill-update` | skill の追加・更新を catalog から生成し Hermes へ同期 | low | catalog |
| `status-reporting` | 進捗・結果・未完事項を簡潔で正確に報告 | low | catalog |
| `subagent-delegation` | delegate_task でサブエージェントへ作業を委譲 | low | catalog |
| `task-prioritization` | タスクを緊急度・重要度・依存で優先順位付け (/priorities) | low | catalog |
| `task-resume` | 中断した作業を状態復元して再開 (/pickup) | low | catalog |
| `workflow-orchestration` | 複数ステップの作業を依存関係付きで設計・実行・追跡 | low | catalog |

## core (9)

| Skill | 説明 | risk | source |
|---|---|---|---|
| `context-builder` | 必要最小限の Context を組み立て、溢れたら要約・分割する | low | hand-written |
| `fallback` | 失敗を分類し代替経路で再試行する汎用 Fallback Engine | medium | hand-written |
| `fallback-model-routing` | モデル障害・能力不足時の代替モデル経路と検証手順 | medium | hand-written |
| `kiridev-state` | タスク/ルート/Fallback/検証結果を SQLite に記録・参照する | low | hand-written |
| `model-router` | Local-first で Strata を使い、能力不足時のみ上位モデルへ昇格 | medium | hand-written |
| `permission-policy` | KiriDev 権限方針。通常操作は無確認、高リスクのみ確認 | high | hand-written |
| `provider-routing` | Hermes の provider/fallback 設定を確認・追加・修復する | medium | hand-written |
| `skill-router` | 依頼から必要な Skill だけを選んでロードする（全 Skill 投入禁止） | low | hand-written |
| `tool-router` | タスクに必要なツールだけを選び、無ければ導入・代替する | low | hand-written |

## cpp-windows (11)

| Skill | 説明 | risk | source |
|---|---|---|---|
| `cmake` | CMake による C++ プロジェクトの構成・ビルド | low | catalog |
| `concurrency` | C++ の並行処理・スレッド安全性の設計と検証 | low | catalog |
| `directx11` | Direct3D 11 の初期化・描画・シェーダ実装 | low | catalog |
| `directx12` | Direct3D 12 の初期化・同期・コマンドリスト実装 | low | catalog |
| `ecs` | ECS (Entity Component System) の設計と実装 | low | catalog |
| `graphics-debugging` | PIX/RenderDoc による描画不具合の調査 | low | catalog |
| `memory-performance` | C++ のメモリ・CPU 性能の計測と最適化 | low | catalog |
| `msbuild` | MSBuild による .sln/.vcxproj のビルドと診断 | low | catalog |
| `msvc` | MSVC (cl/link) コンパイラ・リンカの利用と診断 | low | catalog |
| `physics-integration` | 物理エンジンのゲーム/アプリへの統合 | low | catalog |
| `win32` | Win32 API のウィンドウ・メッセージ・エラー処理の実装 | low | catalog |

## creative (6)

| Skill | 説明 | risk | source |
|---|---|---|---|
| `3d-pipeline` | 3D 制作パイプライン（モデリング〜エンジン組込）設計 | low | catalog |
| `asset-generation` | 画像/音声などアセットの生成・変換・命名管理 | medium | catalog |
| `blender-assist` | Blender のスクリプト・バッチ処理・レンダ支援 | low | catalog |
| `creative-direction` | ビジュアル/世界観の方向性決定とスタイルガイド作成 | low | catalog |
| `level-design` | レベル設計（動線・難易度曲線・ペーシング） | low | catalog |
| `story-writing` | 物語・キャラクター・台詞の執筆と構成 | low | catalog |

## data (11)

| Skill | 説明 | risk | source |
|---|---|---|---|
| `charting` | グラフ作成（matplotlib/plotly）と可視化の選定 | low | catalog |
| `csv-tsv` | CSV/TSV の読み込み・変換・検証（文字コード/区切り対応） | low | catalog |
| `data-analysis` | 探索的データ分析（EDA）と傾向・要因の把握 | low | catalog |
| `data-cleaning` | 欠損・重複・表記ゆれ・型の整形（クレンジング） | low | catalog |
| `json` | JSON の整形・検証・変換・クエリ（jq/Python/PowerShell） | low | catalog |
| `report-generation` | 分析結果のレポート（Markdown/HTML/PDF/docx）作成 | low | catalog |
| `spreadsheet` | Excel/スプレッドシート（xlsx）の読み書き・数式・集計 | low | catalog |
| `sqlite` | SQLite DB の作成・クエリ・インポート/エクスポート | medium | catalog |
| `statistics` | 統計検定・信頼区間・回帰の適切な適用と解釈 | low | catalog |
| `xml` | XML の解析・XPath 抽出・変換・検証 | low | catalog |
| `yaml` | YAML の編集・検証・変換（インデント/型の落とし穴対策） | low | catalog |

## development (13)

| Skill | 説明 | risk | source |
|---|---|---|---|
| `benchmarking` | 再現可能なベンチマークの設計と結果比較 | low | catalog |
| `build-systems` | ビルド構成の作成・修復（CMake/MSBuild/npm scripts 等） | low | catalog |
| `debugging` | 再現から根本原因特定・回帰テストまでの体系的デバッグ | low | catalog |
| `dependency-management` | 依存パッケージの追加・更新・脆弱性確認 | medium | catalog |
| `git` | Git の status/diff/log/branch/stash/worktree 操作 | medium | catalog |
| `package-release` | バージョニング・成果物作成・リリース準備 | high | catalog |
| `profiling-performance` | CPU/メモリのボトルネックを計測して特定する | low | catalog |
| `refactoring` | 挙動を変えず構造を改善する安全なリファクタリング | medium | catalog |
| `requirements-analysis` | 要件の抽出・曖昧さ解消・受け入れ基準の定義 | low | catalog |
| `software-architecture` | モジュール境界と依存方向を決めるアーキテクチャ設計 | low | catalog |
| `system-design` | スケール・可用性・データフローを含むシステム設計 | low | catalog |
| `tdd` | Red→Green→Refactor によるテスト駆動開発 | low | catalog |
| `testing` | テスト設計・実行・失敗解析（pytest/jest/dotnet test 等） | low | catalog |

## documents (18)

| Skill | 説明 | risk | source |
|---|---|---|---|
| `chart-analysis` | Office のグラフ(charts) の系列・値・種類を抽出 | low | catalog |
| `document-authoring` | 新規文書(docx/pptx/xlsx/md)を構成から作成 | low | catalog |
| `document-comparison` | 2つの文書の差分を本文・表・書式レベルで比較 | low | catalog |
| `document-editing` | 既存文書を書式を保ったまま編集 | medium | catalog |
| `document-structure-analysis` | 文書の見出し・章立て・表・図・参照構造を解析 | low | catalog |
| `document-summarization` | 長文・複数文書を要点・決定事項・TODO に要約 | low | catalog |
| `embedded-media-extraction` | Office 内の埋め込み画像・動画・OLE を抽出して解析 | low | catalog |
| `excel-xlsx` | Excel(.xlsx) のシート・数式・グラフ・表の読取 | low | catalog |
| `ocr-fallback` | 他手段で読めない画像・スキャンを tesseract で OCR | low | catalog |
| `office-native-automation` | PowerShell COM で Word/Excel/PowerPoint をネイティブ操作 | medium | catalog |
| `office-ooxml-inspection` | OOXML(zip) を直接展開して document.xml/rels/media を調査 | low | catalog |
| `office-rendering` | Office 文書を PDF/画像へ描画して視覚的に確認 | low | catalog |
| `powerpoint-pptx` | PowerPoint(.pptx) のスライド・ノート・図の解析 | low | catalog |
| `smartart-analysis` | SmartArt(diagrams) の構造とテキストを抽出 | low | catalog |
| `speaker-notes-analysis` | PowerPoint のスピーカーノートを抽出・要約 | low | catalog |
| `table-reconstruction` | 文書・画像・PDF 内の表を構造化データ(CSV/表)へ復元 | low | catalog |
| `universal-document-ingestion` | Office/PDF/画像入り文書を Fallback Chain で漏れなく抽出 | low | hand-written |
| `word-docx` | Word(.docx) の読取・解析（python-docx→OOXML→COM の順） | low | catalog |

## external (19)

| Skill | 説明 | risk | source |
|---|---|---|---|
| `skill-creator` | Create new skills, modify and improve existing skills, and measure skill performance. U... | external | external |
| `ponytail` | Forces the laziest solution that actually works, simplest, shortest, most minimal. Chan... | external | external |
| `ponytail-audit` | Whole-repo audit for over-engineering. Like ponytail-review, but scans the entire codeb... | external | external |
| `ponytail-debt` | Harvest every `ponytail:` comment in the codebase into a debt ledger, so the deliberate... | external | external |
| `ponytail-review` | Code review focused exclusively on over-engineering. Finds what to delete: reinvented s... | external | external |
| `grill-me` | A relentless interview to sharpen a plan or design. | external | external |
| `grilling` | Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to... | external | external |
| `brainstorming` | You MUST use this before any creative work - creating features, building components, ad... | external | external |
| `dispatching-parallel-agents` | Use when facing 2+ independent tasks that can be worked on without shared state or sequ... | external | external |
| `executing-plans` | Use when executing an implementation plan in the current session as the implementer you... | external | external |
| `finishing-a-development-branch` | Use when implementation is complete, all tests pass, and you need to decide how to inte... | external | external |
| `receiving-code-review` | Use when receiving code review feedback, before implementing suggestions, especially if... | external | external |
| `subagent-driven-development` | Use when executing implementation plans with independent tasks in the current session | external | external |
| `using-git-worktrees` | Use when starting feature work that needs isolation from current workspace or before ex... | external | external |
| `using-superpowers` | Use when starting any conversation - establishes how to find and use skills, requiring ... | external | external |
| `verification-before-completion` | Use when about to claim work is complete, fixed, or passing, before committing or creat... | external | external |
| `writing-plans` | Use when you have a spec or requirements for a multi-step task, before touching code | external | external |
| `writing-skills` | Use when creating new skills, editing existing skills, or verifying skills work before ... | external | external |
| `agent-browser` | Browser automation CLI for AI agents. Use when the user needs to interact with websites... | external | external |

## game-development (15)

| Skill | 説明 | risk | source |
|---|---|---|---|
| `asset-pipeline` | テクスチャ・モデル・音声のインポート/最適化パイプライン | low | catalog |
| `game-ai` | ゲーム AI（経路探索・ビヘイビアツリー・ステートマシン） | low | catalog |
| `game-debugging` | ゲーム固有の不具合調査（再現・ログ・クラッシュ解析） | low | catalog |
| `game-design` | ゲームデザイン文書・コアループ・バランス設計 | low | catalog |
| `game-networking` | マルチプレイ同期・ネットコード設計と検証 | medium | catalog |
| `gameplay-systems` | 移動・戦闘・インベントリ等のゲームプレイ機構実装 | low | catalog |
| `shader-hlsl` | HLSL シェーダーの作成・最適化・デバッグ | low | catalog |
| `unity` | Unity プロジェクトの構成・C# スクリプト・シーン開発 | medium | catalog |
| `unity-cli` | Unity のバッチモード実行・CLI ビルド・テスト | medium | catalog |
| `unity-editor` | Unity Editor 拡張・Inspector/メニュー/ツール作成 | medium | catalog |
| `unity-profiling` | Unity Profiler/Memory Profiler による性能調査 | low | catalog |
| `unreal-blueprint` | Unreal Blueprint の設計・整理・C++ との連携 | medium | catalog |
| `unreal-build-tool` | UnrealBuildTool/UAT による C++ ビルドとパッケージ化 | medium | catalog |
| `unreal-cpp` | Unreal C++（UCLASS/UPROPERTY/Actor/Component）実装 | medium | catalog |
| `unreal-engine` | Unreal Engine プロジェクト全般の構成・運用 | medium | catalog |

## languages (9)

| Skill | 説明 | risk | source |
|---|---|---|---|
| `bash` | Bash スクリプト作成(Git Bash / WSL)と実行 | low | catalog |
| `c` | C 言語のコード作成・ビルド・デバッグ | low | catalog |
| `cpp` | C++ (C++17/20) のコード作成・ビルド・デバッグ | low | catalog |
| `csharp` | C# / .NET のコード作成・ビルド・テスト | low | catalog |
| `javascript` | JavaScript / Node.js のコード作成・実行・テスト | low | catalog |
| `powershell-scripting` | 再利用可能な PowerShell スクリプト/モジュールの作成 | low | catalog |
| `python` | Python スクリプト作成・venv・pytest 実行 | low | catalog |
| `sql` | SQL の作成・最適化・安全な実行 | high | catalog |
| `typescript` | TypeScript の型設計・ビルド・型チェック | low | catalog |

## multimodal (14)

| Skill | 説明 | risk | source |
|---|---|---|---|
| `audio-analysis` | 音声ファイルの特徴・内容・メタ情報を解析する | low | catalog |
| `diagram-analysis` | 図・フローチャート・ER 図を読み取り構造化する | low | catalog |
| `image-analysis` | 画像の詳細分析(OCR・属性・差分・メタデータ) | low | catalog |
| `image-editing` | 画像のリサイズ・切抜き・変換・注釈を行う | low | catalog |
| `image-generation` | テキストから画像を生成する | medium | catalog |
| `music-audio-tools` | 音声の変換・切出し・結合・正規化を行う | low | catalog |
| `screenshot-analysis` | スクリーンショットから UI 状態・エラーを読み取る | low | catalog |
| `speech-to-text` | 音声を文字起こしする(Whisper 系) | low | catalog |
| `tts` | テキストを音声合成して音声ファイルを作る | low | catalog |
| `ui-ux-analysis` | UI/UX の課題をヒューリスティックに分析・改善提案する | low | catalog |
| `ui-ux-generation` | UI のワイヤー・モック・HTML/CSS 実装を生成する | low | catalog |
| `video-analysis` | 動画の内容・構成・音声を解析して要約する | low | catalog |
| `video-frame-extraction` | 動画から代表フレームや連番画像を抽出する | low | catalog |
| `vision` | 画像の内容を視覚モデルで認識・説明する | low | catalog |

## quality (15)

| Skill | 説明 | risk | source |
|---|---|---|---|
| `artifact-validation` | 生成物（ファイル・ビルド・文書）が正しく使えるか検証 | low | catalog |
| `code-review` | 差分をバグ・設計・保守性の観点でレビュー | low | catalog |
| `dead-code-removal` | 未使用コード・依存・ファイルを特定して安全に削除 | medium | catalog |
| `independent-review` | 実装者と別視点・別コンテキストでの独立検証 | low | catalog |
| `lint-typecheck` | lint と型チェックを実行して指摘を解消 | low | catalog |
| `memory-leak-analysis` | メモリリーク・肥大化の調査と原因特定 | low | catalog |
| `overengineering-detection` | 過剰設計・不要な複雑性の兆候を検出して指摘 | low | catalog |
| `performance-audit` | プロファイルとベンチで性能ボトルネックを特定 | low | catalog |
| `regression-testing` | 変更で既存機能が壊れていないかを回帰テストで確認 | low | catalog |
| `release-readiness` | リリース前チェック（テスト・版・変更履歴・成果物） | medium | catalog |
| `simplicity-yagni` | YAGNI 観点で不要な機能・抽象を排して最小実装にする | low | catalog |
| `spec-compliance` | 実装が仕様・要件を満たすかを項目単位で照合 | low | catalog |
| `static-analysis` | 静的解析でバグ・脆弱性・危険パターンを検出 | low | catalog |
| `test-coverage` | テストカバレッジを計測し未検証領域を特定 | low | catalog |
| `verification` | 完了宣言前の検証原則。実行証拠なしに完了と言わない | low | hand-written |

## research (18)

| Skill | 説明 | risk | source |
|---|---|---|---|
| `browser-automation` | ブラウザ操作で Web ページを閲覧・操作する | medium | catalog |
| `citation-management` | 出典を一貫した形式で記録・管理する | low | catalog |
| `community-research` | Reddit・HN・フォーラムの評判と実体験を調べる | low | catalog |
| `competitive-research` | 競合製品・サービスの機能と価格を比較調査する | low | catalog |
| `deep-research` | 多段階の調査で網羅的なレポートを作る | low | catalog |
| `download-management` | ファイルを安全にダウンロードし検証・整理する | medium | catalog |
| `fact-checking` | 主張の真偽を証拠に基づき判定する | low | catalog |
| `form-interaction` | Web フォームを入力し検索・申請操作を行う | high | catalog |
| `github-research` | gh CLI で GitHub のリポジトリ・Issue・PR を調査する | low | catalog |
| `market-research` | 市場規模・動向・統計を出典付きで調査する | low | catalog |
| `primary-source-first` | 一次情報(公式・原典)を最優先で参照する | low | catalog |
| `product-research` | 製品・ツールの仕様・評価・導入可否を調べる | low | catalog |
| `site-navigation` | サイト構造を辿り目的のページ・情報へ到達する | low | catalog |
| `source-verification` | 情報源の信頼性と日付・一次性を検証する | low | catalog |
| `technical-docs-research` | 技術ドキュメント・API 仕様を調べて使い方を確定する | low | catalog |
| `web-archiving` | Wayback 等で Web ページを保存・過去版を参照する | low | catalog |
| `web-research` | Web 検索で一次情報を集め要点を整理する | low | catalog |
| `x-search` | X(Twitter) 上の言及・反応を検索して要約する | low | catalog |

## security (6)

| Skill | 説明 | risk | source |
|---|---|---|---|
| `dependency-audit` | 依存パッケージの既知脆弱性・ライセンス監査 | low | catalog |
| `network-security-review` | 公開ポート・FW・TLS 設定のセキュリティ確認 | medium | catalog |
| `permission-audit` | ファイル・サービス・ユーザー権限の過剰付与の監査 | low | catalog |
| `secret-scan` | リポジトリ内の API キー・認証情報の検出 | medium | catalog |
| `security-review` | コード・設定の脆弱性レビューと是正案の提示 | low | catalog |
| `supply-chain-review` | 依存・ビルド・配布物のサプライチェーンリスク確認 | medium | catalog |

## system (27)

| Skill | 説明 | risk | source |
|---|---|---|---|
| `archive-compression` | zip/7z/tar の圧縮・展開 | low | catalog |
| `backup-restore` | ファイル/設定のバックアップと復元 | medium | catalog |
| `cmd` | cmd.exe とバッチファイルの実行・変換 | low | catalog |
| `docker` | Docker コンテナ/イメージの実行と管理 | medium | catalog |
| `docker-compose` | docker compose による複数コンテナ構成の管理 | medium | catalog |
| `environment-variables` | 環境変数と PATH の確認・設定 | medium | catalog |
| `filesystem` | ファイル・フォルダの検索・コピー・移動・整理 | medium | catalog |
| `gpu-nvidia` | NVIDIA GPU の状態確認とドライバ/CUDA 診断 | low | catalog |
| `hardware-diagnostics` | ハードウェア情報の取得と障害診断 | low | catalog |
| `http-api` | HTTP API の呼び出し・検証 | medium | catalog |
| `logs-event-viewer` | イベントログとアプリログの調査 | low | catalog |
| `network-diagnostics` | 接続・DNS・ポート・経路の診断 | low | catalog |
| `package-management` | winget/choco/scoop/pip/npm によるパッケージ管理 | medium | catalog |
| `permissions-acl` | ファイル/フォルダの ACL・所有者・権限の確認と変更 | high | catalog |
| `powershell` | PowerShell 5.1/7 のコマンド実行とパイプライン処理 | medium | catalog |
| `process-management` | プロセスの一覧・監視・起動・停止 | medium | catalog |
| `registry` | レジストリの参照・バックアップ・変更 | high | catalog |
| `remote-desktop-assist` | リモートデスクトップ接続と画面共有の支援 | high | catalog |
| `remote-execution` | リモートホストでのコマンド実行(WinRM/SSH) | high | catalog |
| `scheduled-tasks` | タスクスケジューラの作成・確認・削除 | medium | catalog |
| `service-management` | Windows サービスの状態確認・起動停止・設定 | high | catalog |
| `software-installation` | インストーラ(msi/exe/msix)の安全な導入とアンインストール | high | catalog |
| `ssh` | OpenSSH による接続・鍵管理・ポート転送 | high | catalog |
| `storage-management` | ディスク・パーティション・容量の確認と整理 | high | catalog |
| `system-monitoring` | CPU/メモリ/ディスク/ネットワーク使用状況の監視 | low | catalog |
| `windows-control` | Windows 11 の設定・ウィンドウ・アプリ操作を自動化する | medium | catalog |
| `wsl-linux` | WSL2 の Linux 環境操作とファイル連携 | medium | catalog |

## web-backend (13)

| Skill | 説明 | risk | source |
|---|---|---|---|
| `api-design` | REST/OpenAPI の API 仕様設計とバージョニング | low | catalog |
| `auth` | 認証・認可（JWT/OAuth2/セッション）の安全な実装 | high | catalog |
| `backend-api` | REST/HTTP バックエンド API の実装とテスト | medium | catalog |
| `database-design` | スキーマ設計・正規化・インデックス・マイグレーション | medium | catalog |
| `frontend` | フロントエンド実装・UI 確認・ビルド全般 | low | catalog |
| `html-css` | セマンティック HTML と CSS（Flex/Grid）の実装・修正 | low | catalog |
| `mysql` | MySQL の接続・クエリ・チューニング・バックアップ | high | catalog |
| `nginx` | nginx のリバースプロキシ・静的配信・設定検証 | high | catalog |
| `nodejs` | Node.js アプリ・スクリプトの開発と実行 | low | catalog |
| `postgresql` | PostgreSQL の接続・クエリ・チューニング・バックアップ | high | catalog |
| `react` | React コンポーネント・フック・状態管理の実装 | low | catalog |
| `redis` | Redis のキャッシュ・キュー・セッション運用とデバッグ | medium | catalog |
| `websocket` | WebSocket 双方向通信の実装・接続デバッグ | medium | catalog |

## workflow (25)

| Skill | 説明 | risk | source |
|---|---|---|---|
| `audit` | コード/依存/権限/Secret/設定を横断監査し優先順に報告 | low | hand-written |
| `benchmark` | 速度/品質ベンチを再現可能に計測し記録（モデル含む） | low | hand-written |
| `checkpoint` | 作業状態を .kiridev/checkpoint.md と git/snapshot に保存 | low | hand-written |
| `claude-worker` | 実装・調査を Claude Code ultra ワーカーへ委譲（/worker-on 時のみ） | medium | hand-written |
| `commit` | 全変更を履歴の書式に合わせて 1 コミット | low | ported from qwen-skills/commit |
| `compus` | commit してから push（/commit + /push） | medium | ported from qwen-skills/compus |
| `diagnose` | 再現→証拠→仮説→計測→根本原因→修正→回帰テスト→検証 | low | hand-written |
| `doctor` | KiriDev/Hermes/Strata 環境を診断し安全な問題は自動修復 | medium | hand-written |
| `feature` | 新機能を要件→設計→タスク→実装→検証まで進める入口 | medium | ported from qwen-skills/feature |
| `handoff-sonnet` | 設計まで行い Claude Sonnet コンソールへ実装を引き継ぐ | medium | ported from qwen-skills/handoff-sonnet |
| `i-have-adhd` | ADHD 向け出力整形モード（次の行動を先頭に） | low | external mirror ayghri/i-have-adhd (see UPSTREAM.md) |
| `kiri-handoff` | 別PC/別Session向けに作業状態を記録し commit/push（/handoff 相当） | medium | hand-written |
| `overnight` | 指定時間の自律作業（checkpoint/復旧/最終報告つき） | medium | ported from qwen-skills/overnight |
| `overnight-goal` | ゴール達成まで自律作業（/overnight のゴール版） | medium | ported from qwen-skills/overnight-goal |
| `pickup` | 引き継ぎ/Checkpoint/git から現在地を復元し作業を再開 | low | ported from qwen-skills/pickup |
| `priorities` | 未完了タスクを優先度順に表示するだけ（着手しない） | low | ported from qwen-skills/priorities |
| `pull` | 現在ブランチを fast-forward のみで更新 | low | ported from qwen-skills/pull |
| `push` | 現在ブランチを push（force 禁止） | medium | ported from qwen-skills/push |
| `research` | 一次情報優先で調査し、出典つきで結論を出す（/research） | low | hand-written |
| `retro` | 作業の振り返りから Skill/Routing/Fallback 改善候補を出す | low | hand-written |
| `skill-create` | KiriDev 形式の新 Skill を作成し index 更新と同期まで行う | low | hand-written |
| `speckit-autonomous` | 質問せず仕様作成から実装・検証まで自律実行 | medium | ported from qwen-skills/speckit-autonomous |
| `speckit-require` | Spec Kit で spec/plan/tasks を作成・追記（実装しない） | low | ported from qwen-skills/speckit-require |
| `speckit-update` | Spec Kit の上流更新をローカル規約を保って取り込む | medium | ported from qwen-skills/speckit-update |
| `verify` | Build/Test/Lint/型/実行/差分/仕様準拠を検証して完了判定 | low | hand-written |

## Hermes 既存機能の再利用（Skill を作らず割り当て）

| 指示書の項目 | Hermes 機能 |
|---|---|
| Skill Registry / Skill Index | skills ディレクトリ + system prompt の skills index（skills_list / skill_view の progressive disclosure） |
| /review | built-in /review（独立 reviewer subagent）。観点は quality/code-review Skill |
| /rollback, rollback | built-in /rollback + /snapshot（filesystem checkpoints） |
| /worktree, git-worktree | built-in /worktree（CLI） |
| /handoff（別PC引き継ぎ） | built-in /handoff は messaging platform への引き継ぎで別物 → KiriDev 版は /kiri-handoff |
| pdf | bundled skill pdf（productivity/pdf） |
| systematic debugging / tdd 補助 | bundled skills systematic-debugging, test-driven-development |
| Claude Code / Codex escalation | bundled skills claude-code, codex（CLI へ委譲）+ /model provider 切替 + fallback_providers |
| Tool Router（MCP/plugin tool の遅延公開） | Tool Search（tool_search/tool_describe/tool_call）+ toolsets |
| Model Fallback（provider 障害時） | config.yaml fallback_providers（turn 単位で自動切替） |
| Permission Policy 実行層 | approvals.mode=smart + approvals.deny + smart_policy, --yolo |
| Context Overflow | compression（自動要約）+ /compress + delegate_task subagent |
| Self Improvement | background review / curator / /refine（skill_manage で候補 patch） |
| cron / overnight 継続 | cronjob tool / hermes cron, /goal, /heartbeat |
| Logging / State (SQLite) | %LOCALAPPDATA%\hermes\state.db（sessions, tool calls）+ kanban.db。KiriDev 追加分は .kiridev/state.db |
| Skill 作成 | skill_manage tool, /learn, bundled hermes-agent-skill-authoring |
