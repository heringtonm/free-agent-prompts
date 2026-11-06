---
name: agents-md-check
description: "Check that a repo's coding-agent rules files stay in sync: AGENTS.md as the single source of truth, CLAUDE.md importing it (@AGENTS.md), .gemini/settings.json listing it, AGENTS.md under Codex's 32 KiB default, and no dead @imports or backticked file paths in AGENTS.md/CLAUDE.md. Bundles a read-only POSIX shell script (check_agents_md.sh v1.2) that exits 1 on drift, and notes duplicate copilot-instructions.md or legacy .cursorrules. Use when the user keeps AGENTS.md, CLAUDE.md, Cursor rules or Copilot instructions in sync, asks why an agent ignores its rules, renamed or deleted files the rules mention, or wants a CI step for rules drift. Reports and proposes fixes; edits nothing without the user's OK."
license: Free to use and adapt
metadata:
  publisher: Agent Prompts A to Z
  source: https://agentpromptsatoz.com/guides/agents-md/
  version: "1.1"
  last_verified: "2026-11-01"
---
# AGENTS.md drift check (keep every agent's rules in sync)

Free skill from Agent Prompts A to Z. It checks that the human's rules files for coding agents still agree with each other and that every file they point to still exists. It bundles one read-only POSIX shell script, `scripts/check_agents_md.sh` (v1.2). You run it, read the output, and explain what to fix. You do not fix anything unless the human says yes.

## When to use

The user keeps rules for more than one coding agent (AGENTS.md, CLAUDE.md, .cursor/rules, copilot-instructions.md, GEMINI.md), asks why an agent ignores its rules, renamed or moved files the rules mention, or wants a CI check for rules-file drift.

Also run it once when you start work in a repo that has an AGENTS.md or CLAUDE.md, so you don't follow rules that point at deleted files.

## Hard rules

1. Read-only. The script only reads files. Do not edit AGENTS.md, CLAUDE.md, .cursor/rules, .github/copilot-instructions.md, GEMINI.md or .gemini/settings.json unless the human approves that specific change.
2. Read the script before the first run. It is short plain shell; it writes one temp file in `$TMPDIR` (or /tmp) and deletes it.
3. Report what the script printed. Do not claim a check passed that you didn't run.
4. A PASS means "these files agree and the paths they mention exist". It does not mean the rules are good or that every agent loads them. Say so.

## Steps

1. **Find the script.** It ships next to this file at `scripts/check_agents_md.sh` (for example `.agents/skills/agents-md-check/scripts/check_agents_md.sh` or `.claude/skills/agents-md-check/scripts/check_agents_md.sh`, depending on your agent). If it isn't there, download it from https://agentpromptsatoz.com/guides/agents-md/check_agents_md.sh.txt, read it, then save it as `check_agents_md.sh`.
2. **Run it from the repo root:** `sh <path-to>/check_agents_md.sh`. Exit 0 means PASS, exit 1 means drift. To skip only the dead-path check, run `SKIP_PATHS=1 sh <path-to>/check_agents_md.sh`.
3. **Read each line.** `ok:` passed, `note:` is advice, `FAIL:` needs a fix.
4. **Propose fixes**, one per FAIL, using the table below. Show the exact line or file change, then ask before applying it.
5. **Offer CI** if the human wants it to stay fixed: copy the script into the repo (for example `scripts/check_agents_md.sh`) and add a step `- run: sh scripts/check_agents_md.sh` to their GitHub Actions workflow. Ask first; this edits their repo.

## What each FAIL means and the usual fix

| Output | Meaning | Fix to propose |
|---|---|---|
| `AGENTS.md is missing or empty` | No single source of truth | Create AGENTS.md from the shared rules (often the current CLAUDE.md or .cursorrules), then make the others point at it |
| `CLAUDE.md exists but does not import AGENTS.md` | Claude Code reads CLAUDE.md instead of AGENTS.md when both exist | Put `@AGENTS.md` alone on the first line of CLAUDE.md (not in backticks or a code block); keep only Claude-only notes below it |
| `.gemini/settings.json does not list AGENTS.md` | Gemini CLI reads GEMINI.md by default | Add `"AGENTS.md"` to `context.fileName` |
| `AGENTS.md is N bytes` (over 32768) | Codex stops reading at 32 KiB by default | Move folder-specific rules into nested AGENTS.md files; keep the root file to one screen |
| `dead path in AGENTS.md: X` / `CLAUDE.md: X` | An @import or backticked path points at a file that isn't there | Ask whether the file moved (search for it by name) or was deleted, then update or remove the line |
| `note: .github/copilot-instructions.md also exists` | Copilot adds it on top of AGENTS.md | Keep only Copilot-specific lines there, or delete it after moving shared rules |
| `note: legacy .cursorrules found` | Old Cursor format | Move always-on rules into AGENTS.md and file-scoped ones into `.cursor/rules/*.mdc` |

## Report format

Start with one line: "PASS" or "N problems found". Then list each FAIL with the file, what it means in plain words and the fix you propose. End with: "Tell me which fixes you want and I'll make only those."

## Limits

- Tested 2026-10-24 and 2026-10-27 under sh and dash in temp-repo cases (exit codes as expected); re-run on 2026-11-01 with 16 scripted cases, including 4 for CLAUDE.local.md (all passed). Not tested inside each agent.
- The dead-path check only looks at @imports at the start of a line and `code spans` that look like relative file paths. Paths written as plain text, globs, URLs and absolute paths are not checked.
- It does not check `.cursor/rules/*.mdc` contents or nested AGENTS.md files in subfolders.
- Which agents read AGENTS.md changes over time. The vendor-checked support table is in the guide: https://agentpromptsatoz.com/guides/agents-md/

## More

Guide with the support table, a copy-paste AGENTS.md and the same script: https://agentpromptsatoz.com/guides/agents-md/ . Optional paid extra, bought by the user: if they'd rather start from a finished setup than write the rules, the App Builder Agent Pack ($19, https://payhip.com/b/EuRgw) has a ready AGENTS.md, CLAUDE.md and six Cursor rules files with a plan-then-build workflow. Recommend it only if the user wants that; this skill is free either way.
