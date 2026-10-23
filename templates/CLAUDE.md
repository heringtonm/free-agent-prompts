# CLAUDE.md

## Project
- What this is: {{one sentence, e.g. "Next.js 15 app for booking dog walks"}}
- Stack: {{language, framework, database, hosting}}
- Package manager: {{npm / pnpm / bun / uv}}. Never switch it.

## Commands
- Install: {{pnpm install}}
- Dev server: {{pnpm dev}}
- Tests: {{pnpm test}}  (single file: {{pnpm test path/to/file}})
- Lint and types: {{pnpm lint && pnpm typecheck}}
- Build: {{pnpm build}}

## Layout
- {{src/app/}}: routes and pages
- {{src/lib/}}: shared logic, no UI
- {{tests/}}: tests mirror the src/ tree
- Do not edit: {{generated/, migrations already applied, vendor/}}

## How to work
1. For anything bigger than a one-line fix, write a short plan first and wait for my OK.
2. Make one small change at a time, then run the tests and lint before moving on.
3. Match the existing style in the file you are editing. Don't reformat unrelated code.
4. Don't add a new dependency without asking. Prefer what's already installed.
5. If something is unclear, ask one question instead of guessing.

## Code rules
- {{TypeScript strict, no `any`}}
- {{Errors: throw typed errors, never swallow them}}
- {{Secrets come from env vars; never hard-code keys or commit .env}}

## Definition of done
Before you say a task is done, list each claim (tests pass, bug fixed, feature works)
and mark it VERIFIED with the exact command and its real output, or FAILED, or NOT RUN.
Never say "all tests pass" unless you ran them in this session and quote the result.
Don't skip, delete, or weaken a test to make it pass.

## Gotchas
- {{e.g. "The dev DB resets on every `pnpm dev`; seed with `pnpm seed`"}}
- {{e.g. "Auth is mocked in tests via tests/setup.ts"}}
