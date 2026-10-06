---
name: handoff
description: "Save the current work state for resuming on another PC: write .handoff/HANDOFF.md (done / remaining / on hold / next step), then commit everything and push. Resume elsewhere with /pull then /pickup."
argument-hint: "[optional note for the next session]"
---

## Task

Prepare this repository so the work can be resumed on another PC, then commit and push.

First run `git status -sb`, `git diff HEAD --stat`, `git log --oneline -5` and `git stash list` (with whatever shell tool is available).

1. **Write the handoff note** at `.handoff/HANDOFF.md` (create the `.handoff/` folder if missing; overwrite the previous note). Use the current conversation, task/plan items, `TODO.md` / `specs/**/tasks.md`, and the git state. Write it in Japanese, in this shape:

   ```
   # 引き継ぎ (<YYYY-MM-DD HH:MM> / <branch>)

   次の一手: <one concrete action to start with on the other PC>

   ## 完了
   - ... (`file:line` or commit)
   ## 残り（優先順・最大5件）
   - ...
   ## 保留
   - <task> — <what it is waiting for>
   ## 再開に必要なもの
   - <setup the other PC needs: install commands, env vars to set (names only, never values), files not in git>
   ```

   If `$ARGUMENTS` is given, add it under `## メモ`. Keep it short; omit empty sections.

2. **Make sure needed files are in git**:
   - Create any folders the project needs that git would drop because they are empty (add a `.gitkeep`), only if code or docs reference them.
   - Stage all untracked work files. Do NOT stage secrets (`.env*`, credentials, keys, tokens) or build/cache output (`node_modules`, `__pycache__`, `dist`, logs). If such files are not ignored, add them to `.gitignore` instead and list them in the handoff note under `再開に必要なもの` (names only).
   - If `git stash list` is not empty, mention the stashes in the note (stashes are not pushed).

3. **Commit**: `git add -A` (minus skipped files) and `git commit -m "chore: handoff <short summary>"` in the style of recent commits.

4. **Push**: `git push`, or `git push -u origin <branch>` if no upstream. Never force-push. If rejected, report the error and stop (do not merge or rebase).

5. Report in 2 to 3 lines: commit hash, push result, and the resume steps on the other PC: `/pull` then `/pickup`.
