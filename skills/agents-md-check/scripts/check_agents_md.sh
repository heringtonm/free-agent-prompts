#!/usr/bin/env sh
# check_agents_md.sh - fail if your agent rules files have drifted apart.
# Free from https://agentpromptsatoz.com/guides/agents-md/ . Read-only; changes nothing.
# Usage: sh check_agents_md.sh   (run from the repo root, locally or in CI)
# v1.1 (2026-10-27): also fails on dead paths: @imports and `backticked/paths` in AGENTS.md
# and CLAUDE.md that don't exist. Set SKIP_PATHS=1 to skip that check.
# v1.2 (2026-11-01): fails when a personal CLAUDE.local.md silently stops Claude Code reading
# AGENTS.md (it counts as a CLAUDE.md), unless some CLAUDE file imports AGENTS.md.
fail=0
say(){ printf '%s\n' "$1"; }
if [ ! -s AGENTS.md ]; then say "FAIL: AGENTS.md is missing or empty (it is the single source of truth)"; exit 1; fi
say "ok: AGENTS.md found"
size=$(wc -c < AGENTS.md | tr -d ' ')
if [ "$size" -gt 32768 ]; then say "FAIL: AGENTS.md is $size bytes; Codex stops reading at 32 KiB by default"; fail=1; else say "ok: AGENTS.md is $size bytes (Codex default cap is 32768)"; fi
for f in CLAUDE.md .claude/CLAUDE.md; do
  [ -e "$f" ] || continue
  if [ -L "$f" ]; then say "ok: $f is a symlink to $(readlink "$f")"; continue; fi
  if grep -Eq '^[[:space:]]*@(\./)?AGENTS\.md[[:space:]]*$' "$f"; then say "ok: $f imports @AGENTS.md"
  else say "FAIL: $f exists but does not import AGENTS.md. Claude Code reads CLAUDE.md instead of AGENTS.md when both exist; add a line: @AGENTS.md"; fail=1; fi
done
if [ -e CLAUDE.local.md ]; then
  imp=0
  for f in CLAUDE.md .claude/CLAUDE.md CLAUDE.local.md; do
    [ -e "$f" ] || continue
    if [ -L "$f" ] && [ "$(basename "$(readlink "$f")")" = AGENTS.md ]; then imp=1; fi
    grep -Eq '^[[:space:]]*@(\./)?AGENTS\.md[[:space:]]*$' "$f" 2>/dev/null && imp=1
  done
  if [ $imp = 1 ]; then say "ok: CLAUDE.local.md found, and AGENTS.md is still imported (local notes load after it)"
  else say "FAIL: CLAUDE.local.md exists but nothing imports AGENTS.md. Claude Code counts CLAUDE.local.md as a CLAUDE.md and stops reading AGENTS.md; add a line @AGENTS.md to CLAUDE.local.md (or a CLAUDE.md), or set Project instructions to claude-md-and-agents-md"; fail=1; fi
fi
if [ -f .gemini/settings.json ]; then
  if grep -q 'AGENTS.md' .gemini/settings.json; then say "ok: .gemini/settings.json lists AGENTS.md"; else say "FAIL: .gemini/settings.json does not list AGENTS.md in context.fileName"; fail=1; fi
fi
if [ -f .github/copilot-instructions.md ]; then
  n=$(grep -c '' .github/copilot-instructions.md | tr -d ' ')
  say "note: .github/copilot-instructions.md also exists ($n lines). Copilot adds it on top of AGENTS.md, so keep it Copilot-only and don't repeat or contradict AGENTS.md"
fi
if [ "${SKIP_PATHS:-0}" != 1 ]; then
  dead=0
  for src in AGENTS.md CLAUDE.md .claude/CLAUDE.md CLAUDE.local.md; do
    [ -f "$src" ] || continue
    # candidate paths: @imports at line start, and `code spans` that look like relative files
    { sed -n 's/^[[:space:]]*@\([^[:space:]]*\).*/\1/p' "$src"
      grep -o '`[^`]*`' "$src" | tr -d '`'; } | while IFS= read -r p; do
      case "$p" in ''|*' '*|*'*'*|*'?'*|*'['*|*'<'*|*'{'*|*'$'*|*'://'*|/*|'~'*|-*|*'|'*|*'='*|*'('*|*':'*) continue;; esac
      p=${p#./}
      case "$p" in */*|*.md|*.json|*.ts|*.tsx|*.js|*.mjs|*.py|*.sh|*.toml|*.yml|*.yaml|*.mdc|*.sql|*.txt) ;; *) continue;; esac
      [ -e "$p" ] || printf '%s\n' "$src: $p"
    done
  done > "${TMPDIR:-/tmp}/agents_md_dead.$$" 2>/dev/null
  if [ -s "${TMPDIR:-/tmp}/agents_md_dead.$$" ]; then
    sort -u "${TMPDIR:-/tmp}/agents_md_dead.$$" | while IFS= read -r l; do say "FAIL: dead path in $l (agents will look for a file that isn't there)"; done; fail=1
  else say "ok: every @import and backticked path in AGENTS.md/CLAUDE files exists"; fi
  rm -f "${TMPDIR:-/tmp}/agents_md_dead.$$"
fi
for f in .cursorrules; do [ -f "$f" ] && say "note: legacy $f found; move it into AGENTS.md or .cursor/rules/*.mdc"; done
[ $fail = 0 ] && say "PASS: one source of truth" || say "FAILED: fix the lines above"
exit $fail
