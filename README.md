# Free Agent Prompts

Free, copy-paste prompt packs for AI coding agents and vibe coders, from [Agent Prompts A to Z](https://agentpromptsatoz.com). Plain Markdown: read any file before you use it.

## Install the Agent Skills

```bash
npx skills add heringtonm/free-agent-prompts
```

List what's inside first, or install one skill:

```bash
npx skills add heringtonm/free-agent-prompts --list
npx skills add heringtonm/free-agent-prompts --skill agent-done-check
```

## What's inside

### `skills/` : 7 Agent Skills (SKILL.md)

| Skill | What it does |
|---|---|
| [agent-done-check](skills/agent-done-check/SKILL.md) | Audits whether an agent really finished: acceptance criteria, a claim-by-claim ledger against raw evidence, and a DONE / NOT DONE / CAN'T TELL verdict. Includes a Definition-of-Done rule for CLAUDE.md / AGENTS.md. |
| [code-reviewer](skills/code-reviewer/SKILL.md) | Reviews a diff, PR or file: bugs first, then security, performance, readability, with quoted lines and suggested fixes. |
| [vibe-coder-bug-explainer](skills/vibe-coder-bug-explainer/SKILL.md) | Explains an error or stack trace in plain English with numbered fix steps. |
| [readme-writer](skills/readme-writer/SKILL.md) | Writes a README using only facts in the input; leaves TODOs instead of inventing details. |
| [inbox-triager](skills/inbox-triager/SKILL.md) | Sorts pasted emails into Act now / Reply / Read later / Archive. Drafts only, never sends. |
| [game-guide-summarizer](skills/game-guide-summarizer/SKILL.md) | Turns a long game guide or patch notes into a short, spoiler-aware cheat sheet. |
| [security-watch](skills/security-watch/SKILL.md) | Read-only check of your projects against a dated table of patched PHP, Node, Next.js and React versions and two known malicious packages (last verified 2026-10-23). Reports what to update with sources; changes nothing without your OK. |

### `rules/` : Cursor rules (.mdc)

Copy a file into your project's `.cursor/rules/` folder.

| Rule | Type | File |
|---|---|---|
| Core working agreement (plan first, small steps, definition of done) | Always Apply | [rules/00-core.mdc](rules/00-core.mdc) |
| Frontend | Specific files | [rules/frontend.mdc](rules/frontend.mdc) |
| Testing | Specific files | [rules/testing.mdc](rules/testing.mdc) |
| Security | Apply Intelligently | [rules/security.mdc](rules/security.mdc) |
| New feature workflow | Manual (`@new-feature`) | [rules/new-feature.mdc](rules/new-feature.mdc) |
| Code Reviewer | | [rules/code-reviewer.mdc](rules/code-reviewer.mdc) |
| Vibe-Coder Bug Explainer | | [rules/vibe-coder-bug-explainer.mdc](rules/vibe-coder-bug-explainer.mdc) |
| README Writer | | [rules/readme-writer.mdc](rules/readme-writer.mdc) |
| Inbox Triager | | [rules/inbox-triager.mdc](rules/inbox-triager.mdc) |
| Game Guide Summarizer | | [rules/game-guide-summarizer.mdc](rules/game-guide-summarizer.mdc) |

Replace every `{{placeholder}}` with your real stack and commands.

### `templates/` : project instruction files

- [templates/CLAUDE.md](templates/CLAUDE.md) for Claude Code
- [templates/AGENTS.md](templates/AGENTS.md) for Codex, Cursor and other agents that read AGENTS.md

Copy one to your repo root. Tip: keep the real rules in AGENTS.md and add a line `@AGENTS.md` to CLAUDE.md so they can't drift.

## Guides and agent-friendly links

- For agents and agent builders: https://agentpromptsatoz.com/for-agents/
- CLAUDE.md template guide: https://agentpromptsatoz.com/guides/claude-md-template/
- Cursor rules guide: https://agentpromptsatoz.com/guides/cursor-rules/

## Want more?

These free packs are the starter set. Paid, tested full packs are at https://agentpromptsatoz.com, for example the App Builder Agent Pack ($19) and the bundle of all 5 premium packs ($29). Nothing here requires buying anything.

## License

[MIT](LICENSE)
