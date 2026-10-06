"""KiriDev runtime state logger (SQLite, stdlib only)."""
import argparse
import os
import sqlite3
import sys
import time
from pathlib import Path

KINDS = ["task", "tool", "route", "fallback", "failure", "verify", "skill", "checkpoint", "benchmark"]
DB = Path(os.environ.get("KIRIDEV_STATE_DB") or
          Path(os.environ.get("LOCALAPPDATA", Path.home())) / "hermes" / "kiridev" / "state.db")


def conn():
    DB.parent.mkdir(parents=True, exist_ok=True)
    c = sqlite3.connect(DB)
    c.execute("""CREATE TABLE IF NOT EXISTS events(
        id INTEGER PRIMARY KEY, ts TEXT, kind TEXT, name TEXT, result TEXT, detail TEXT, project TEXT)""")
    return c


def main(argv=None):
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
    p = argparse.ArgumentParser(prog="kdlog")
    sub = p.add_subparsers(dest="cmd", required=True)
    e = sub.add_parser("event")
    e.add_argument("kind", choices=KINDS)
    e.add_argument("name")
    e.add_argument("--result", default="ok")
    e.add_argument("--detail", default="")
    e.add_argument("--project", default=os.getcwd())
    t = sub.add_parser("tail")
    t.add_argument("-n", type=int, default=20)
    t.add_argument("--kind", choices=KINDS)
    sub.add_parser("stats")
    a = p.parse_args(argv)
    c = conn()
    if a.cmd == "event":
        c.execute("INSERT INTO events(ts,kind,name,result,detail,project) VALUES(?,?,?,?,?,?)",
                  (time.strftime("%Y-%m-%d %H:%M:%S"), a.kind, a.name, a.result, a.detail, a.project))
        c.commit()
        print(f"logged {a.kind}:{a.name}:{a.result} -> {DB}")
    elif a.cmd == "tail":
        q = "SELECT ts,kind,name,result,detail FROM events"
        args = ()
        if a.kind:
            q += " WHERE kind=?"
            args = (a.kind,)
        rows = c.execute(q + " ORDER BY id DESC LIMIT ?", args + (a.n,)).fetchall()
        for r in reversed(rows):
            print(" | ".join(str(x) for x in r))
    else:
        for r in c.execute("SELECT kind,result,COUNT(*) FROM events GROUP BY kind,result ORDER BY kind"):
            print(" | ".join(str(x) for x in r))
    return 0


if __name__ == "__main__":
    sys.exit(main())
