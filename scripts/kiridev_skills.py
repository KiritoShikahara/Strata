"""KiriDev skill registry tool.

Usage (run with the Hermes venv python, which ships PyYAML):
  python scripts/kiridev_skills.py build   # catalog/*.yaml -> skills/<cat>/<name>/SKILL.md, then index
  python scripts/kiridev_skills.py index   # rebuild skills/index.yaml + skills/index.md
  python scripts/kiridev_skills.py check   # validate metadata / names / collisions

Hand-written SKILL.md files (without the GENERATED marker) are never overwritten.
"""
import os
import re
import sys
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parent.parent
SKILLS = ROOT / "skills"
CATALOG = SKILLS / "catalog"
MARKER = "<!-- GENERATED from skills/catalog — edit the catalog, not this file -->"
REQUIRED = ["namespace", "category", "triggers", "required_tools", "optional_tools",
            "dependencies", "conflicts", "workflow", "verification", "fallback", "risk_level"]
# Hermes built-in slash commands that shadow skills of the same name.
HERMES_BUILTIN_COMMANDS = {
    "handoff", "review", "rollback", "worktree", "goal", "plan", "diff", "snapshot", "learn",
    "init", "status", "model", "skills", "tools", "config", "cron", "debug", "update", "new",
}


def q(s):
    return yaml.safe_dump(s, allow_unicode=True, default_flow_style=True, width=10_000).strip()


def render(cat, e, defaults):
    g = {**defaults, **e}
    name = g["name"]
    fm = {
        "name": name,
        "description": g["d"],
        "version": "1.0.0",
        "metadata": {
            "hermes": {"tags": ["kiridev", cat], "category": cat},
            "kiridev": {
                "namespace": "kiridev",
                "category": cat,
                "triggers": g.get("tr", []),
                "required_tools": g.get("tools", []),
                "optional_tools": g.get("opt", []),
                "dependencies": g.get("deps", []),
                "conflicts": g.get("conflicts", []),
                "workflow": "see '## Procedure'",
                "verification": g.get("verify", ""),
                "fallback": g.get("fb", []),
                "risk_level": g.get("risk", "low"),
                "related": g.get("rel", []),
                "source": "catalog",
            },
        },
    }
    out = ["---", yaml.safe_dump(fm, allow_unicode=True, sort_keys=False, width=10_000).rstrip(), "---", MARKER, "",
           f"# {name}", "", g["d"], "", "## When to Use",
           "Trigger: " + ", ".join(str(t) for t in g.get("tr", [])), "",
           "## Tools", f"- required: {', '.join(g.get('tools', [])) or '-'}",
           f"- optional: {', '.join(g.get('opt', [])) or '-'}",
           f"- dependencies: {', '.join(g.get('deps', [])) or '-'}（無ければ `fallback` Skill の tool-missing 経路で導入）", "",
           "## Procedure"]
    out += [f"{i}. {s}" for i, s in enumerate(g.get("steps", []), 1)]
    out += ["", "## Verification", g.get("verify", ""), "", "## Fallback（上から順に試す。すぐユーザーへ投げ返さない）"]
    out += [f"{i}. {s}" for i, s in enumerate(g.get("fb", []), 1)]
    out += ["", "## Related", ", ".join(g.get("rel", [])) or "-", "", "## Prohibited"]
    out += [f"- {s}" for s in g.get("no", [])] or ["- (none)"]
    out += ["- Approval 対象（permission-policy 参照）は実行前に確認する。", ""]
    return "\n".join(out)


def build():
    n = 0
    for f in sorted(CATALOG.glob("*.yaml")):
        if f.name == "reuse.yaml":
            continue
        data = yaml.safe_load(f.read_text(encoding="utf-8"))
        cat, defaults = data["category"], data.get("defaults") or {}
        for e in data["skills"]:
            if False in e:  # YAML 1.1 parses an unquoted `no:` key as boolean False
                e["no"] = e.pop(False)
            p = SKILLS / cat / e["name"] / "SKILL.md"
            if p.exists() and MARKER not in p.read_text(encoding="utf-8"):
                continue  # hand-written skill wins
            p.parent.mkdir(parents=True, exist_ok=True)
            p.write_text(render(cat, e, defaults), encoding="utf-8", newline="\n")
            n += 1
    print(f"generated {n} skills")
    index()


def parse(p):
    text = p.read_text(encoding="utf-8")
    m = re.match(r"^---\r?\n(.*?)\r?\n---", text, re.S)
    if not m:
        raise ValueError(f"{p}: no frontmatter")
    return yaml.safe_load(m.group(1)), text


def all_skills():
    out = []
    for p in sorted(SKILLS.rglob("SKILL.md")):
        rel = p.relative_to(SKILLS).parts
        if rel[0] == "catalog" or any(x in ("references", "templates", "assets", "scripts") for x in rel[:-2]):
            continue
        fm, text = parse(p)
        kd = (fm.get("metadata") or {}).get("kiridev") or {}
        out.append({
            "name": fm["name"],
            "category": rel[0],
            "path": "/".join(rel[:-1]),
            "description": str(fm.get("description", "")).strip(),
            "triggers": kd.get("triggers", []),
            "risk_level": kd.get("risk_level", "external" if rel[0] == "external" else "low"),
            "source": kd.get("source", "external" if rel[0] == "external" else "hand-written"),
            "_kd": kd,
        })
    return out


def index():
    skills = all_skills()
    reuse = yaml.safe_load((CATALOG / "reuse.yaml").read_text(encoding="utf-8"))
    idx = {"version": 1, "generated_by": "scripts/kiridev_skills.py",
           "count": len(skills),
           "skills": [{k: v for k, v in s.items() if not k.startswith("_")} for s in skills],
           "reused_hermes_features": reuse["reused"]}
    (SKILLS / "index.yaml").write_text(
        yaml.safe_dump(idx, allow_unicode=True, sort_keys=False, width=200), encoding="utf-8", newline="\n")
    lines = ["# KiriDev Skill Index", "",
             f"全 {len(skills)} Skill。機械可読版: `skills/index.yaml`。再生成: `python scripts/kiridev_skills.py index`。", ""]
    cats = {}
    for s in skills:
        cats.setdefault(s["category"], []).append(s)
    for c in sorted(cats):
        lines += [f"## {c} ({len(cats[c])})", "", "| Skill | 説明 | risk | source |", "|---|---|---|---|"]
        for s in cats[c]:
            d = s["description"].replace("|", "\\|").replace("\n", " ")
            if len(d) > 90:
                d = d[:87] + "..."
            lines.append(f"| `{s['name']}` | {d} | {s['risk_level']} | {s['source']} |")
        lines.append("")
    lines += ["## Hermes 既存機能の再利用（Skill を作らず割り当て）", "", "| 指示書の項目 | Hermes 機能 |", "|---|---|"]
    lines += [f"| {r['spec']} | {r['hermes']} |" for r in reuse["reused"]]
    (SKILLS / "index.md").write_text("\n".join(lines) + "\n", encoding="utf-8", newline="\n")
    print(f"index: {len(skills)} skills")


def check():
    skills = all_skills()
    errors, names = [], {}
    bundled = set()
    hs = Path(os.environ.get("LOCALAPPDATA", "")) / "hermes" / "hermes-agent" / "skills"
    if hs.exists():
        bundled = {p.parent.name for p in hs.rglob("SKILL.md")}
    for s in skills:
        if s["name"] in names:
            errors.append(f"duplicate name {s['name']}: {names[s['name']]} / {s['path']}")
        names[s["name"]] = s["path"]
        if s["category"] != "external":
            missing = [k for k in REQUIRED if k not in s["_kd"]]
            if missing:
                errors.append(f"{s['path']}: missing metadata {missing}")
            if len(s["description"]) > 60:
                errors.append(f"{s['path']}: description > 60 chars ({len(s['description'])})")
        if s["name"] in bundled:
            errors.append(f"{s['path']}: name collides with Hermes bundled skill")
        if s["name"] in HERMES_BUILTIN_COMMANDS and s["category"] in ("workflow", "core"):
            errors.append(f"{s['path']}: /{s['name']} is shadowed by a Hermes built-in command")
    for e in errors:
        print("ERROR", e)
    print(f"checked {len(skills)} skills, {len(errors)} errors")
    return 1 if errors else 0


if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else "check"
    sys.exit({"build": lambda: build() or 0, "index": lambda: index() or 0, "check": check}[cmd]())
