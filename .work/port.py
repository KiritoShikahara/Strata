import re, shutil, yaml
from pathlib import Path
SRC, DST = Path("qwen-skills"), Path("skills/workflow")
M = {
 "feature": ("新機能を要件→設計→タスク→実装→検証まで進める入口", ["/feature", "機能を追加して", "新機能"], ["terminal","read_file","write_file","patch"], "medium", "tasks.md が全チェック済みで verify が PASS"),
 "speckit-require": ("Spec Kit で spec/plan/tasks を作成・追記（実装しない）", ["/speckit-require", "要件定義", "仕様書", "SPEC-"], ["terminal","read_file","write_file"], "low", "spec.md/plan.md/tasks.md が生成され未解決の明確化が無い"),
 "speckit-autonomous": ("質問せず仕様作成から実装・検証まで自律実行", ["/speckit-autonomous", "自律着手", "質問せず最後まで"], ["terminal","read_file","write_file","patch"], "medium", "全タスク完了または blocked 理由つきで verify PASS"),
 "speckit-update": ("Spec Kit の上流更新をローカル規約を保って取り込む", ["/speckit-update", "Spec Kit 更新"], ["terminal","read_file","write_file"], "medium", "主要スクリプトが動作し旧バージョン表記が残っていない"),
 "handoff-sonnet": ("設計まで行い Claude Sonnet コンソールへ実装を引き継ぐ", ["/handoff-sonnet", "Sonnet に引き継ぎ"], ["terminal","write_file"], "medium", "HANDOFF.md 作成とコンソール起動結果を報告"),
 "pickup": ("引き継ぎ/Checkpoint/git から現在地を復元し作業を再開", ["/pickup", "再開", "続きから"], ["terminal","read_file"], "low", "再開タスクが特定され着手している"),
 "pull": ("現在ブランチを fast-forward のみで更新", ["/pull", "最新を取得"], ["terminal"], "low", "git status で behind 0"),
 "push": ("現在ブランチを push（force 禁止）", ["/push"], ["terminal"], "medium", "git status で ahead 0"),
 "commit": ("全変更を履歴の書式に合わせて 1 コミット", ["/commit", "コミットして"], ["terminal"], "low", "git log -1 に新コミット、git status clean"),
 "compus": ("commit してから push（/commit + /push）", ["/compus"], ["terminal"], "medium", "commit hash と push 結果"),
 "priorities": ("未完了タスクを優先度順に表示するだけ（着手しない）", ["/priorities", "優先順位", "タスク一覧"], ["terminal","read_file"], "low", "最大5件の表と次の一手が出ている"),
 "overnight": ("指定時間の自律作業（checkpoint/復旧/最終報告つき）", ["/overnight", "寝てる間に", "不在の間"], ["terminal","read_file","write_file","patch","todo"], "medium", "期限後に完了/残/保留の報告"),
 "overnight-goal": ("ゴール達成まで自律作業（/overnight のゴール版）", ["/overnight-goal", "達成するまで"], ["terminal","read_file","write_file","patch","todo"], "medium", "完了条件を検証で満たした（または blocked/上限）"),
 "i-have-adhd": ("ADHD 向け出力整形モード（次の行動を先頭に）", ["/i-have-adhd"], [], "low", "出力が次の一手から始まり番号付き"),
}
EXTRA = {
 "overnight": "\n## KiriDev 追加（必須機能）\n- **Checkpoint**: 1 タスク完了ごと / 30 分ごとに `checkpoint` Skill を実行（`.kiridev/checkpoint.md` + WIP commit）。\n- **Crash recovery / Progress persistence**: 開始時に `.kiridev/checkpoint.md` があれば読み、続きから再開。進捗は todo と checkpoint に保存。\n- **継続**: Hermes `/goal`・`cronjob`（例: 30 分ごとに再開プロンプト）を必要に応じて設定し、停止しても再開できるようにする。\n- **Isolation**: 大きな変更は `/worktree new` か作業ブランチ（ユーザー承認済みの範囲）で行う。\n- **Repeated verification**: 各タスク後に `verify` Skill。一時的エラー（network/rate-limit）は fallback Skill で再試行し即停止しない。\n",
 "overnight-goal": "\n## KiriDev 追加\n- Hermes built-in `/goal <完了条件>` が使える場合は併用（standing goal として turn をまたいで継続）。\n- 各サブタスク後 `checkpoint` と `verify` を実行。一時的エラーは fallback Skill で再試行。\n",
 "feature": "\n## KiriDev 追加\n- 実装後は必ず `verify` Skill（Build → Test → Verify → Diff）を通してから報告する。\n- `.specify/` が無いプロジェクトでは Spec Kit を導入せず、`specs/<name>/spec.md, plan.md, tasks.md` を同じ構成で手書きして進めてよい（導入の確認は 1 回だけ）。\n",
 "speckit-autonomous": "\n## KiriDev 追加\n- サブエージェントは Hermes `delegate_task` を使う（agent-team 記述は読み替え）。完了前に `verify` Skill。\n",
 "pickup": "\n## KiriDev 追加\n- `.kiridev/checkpoint.md`（checkpoint Skill）と `kdlog.py tail` も手がかりに含める。引き継ぎメモは `/kiri-handoff` が書く `.handoff/HANDOFF.md`。\n",
}
for name,(d,tr,tools,risk,ver) in M.items():
    src = SRC/name/"SKILL.md"; text = src.read_text(encoding="utf-8")
    body = re.sub(r"^---\r?\n.*?\r?\n---\r?\n", "", text, count=1, flags=re.S)
    body = body.replace("$ARGUMENTS", "（コマンド引数）")
    body = body.replace("`/handoff`", "`/kiri-handoff`").replace("/handoff が", "/kiri-handoff が")
    fm = {"name": name, "description": d, "version": "1.0.0",
          "metadata": {"hermes": {"tags": ["kiridev","workflow"], "category": "workflow"},
             "kiridev": {"namespace":"kiridev","category":"workflow","triggers":tr,"required_tools":tools,"optional_tools":["delegate_task"] if tools else [],
                 "dependencies": ["git"] if "terminal" in tools else [], "conflicts": [], "workflow":"see body",
                 "verification": ver, "fallback": ["fallback Skill（Failure Class 別の代替経路）"], "risk_level": risk,
                 "source": "ported from qwen-skills/"+name}}}
    if name == "i-have-adhd":
        fm["license"] = "MIT"; fm["metadata"]["kiridev"]["source"] = "external mirror ayghri/i-have-adhd (see UPSTREAM.md)"
    out = DST/name; out.mkdir(parents=True, exist_ok=True)
    (out/"SKILL.md").write_text("---\n"+yaml.safe_dump(fm, allow_unicode=True, sort_keys=False, width=10000)+"---\n"+body.rstrip()+"\n"+EXTRA.get(name,""), encoding="utf-8", newline="\n")
    for f in (SRC/name).iterdir():
        if f.name != "SKILL.md":
            (shutil.copytree if f.is_dir() else shutil.copy2)(f, out/f.name, **({"dirs_exist_ok":True} if f.is_dir() else {}))
print("ok")
