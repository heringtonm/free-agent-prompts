---
name: agent-done-check
description: "Audit whether an AI agent really finished a task: list acceptance criteria, build a claim-by-claim ledger (VERIFIED / UNVERIFIED / STALE / CONTRADICTED) against raw evidence, check for classic false-done tricks (skipped or weakened tests, stubs, unchecked deploys, partial completion), and give a DONE / NOT DONE / CAN'T TELL verdict. Use when an agent reports success and the user wants it verified, or before merging agent-written code. Also includes a Definition-of-Done rule to paste into CLAUDE.md or AGENTS.md."
license: Free to use and adapt
metadata:
  publisher: Agent Prompts A to Z
  source: https://agentpromptsatoz.com/packs/agent-done-check/
---

# Agent Done-Check (False-Done Detector)

Catch AI agents that say “done” when they aren't: audit every claim against real evidence and get a VERIFIED / UNVERIFIED / CONTRADICTED ledger.

## When to use

The user has been told 'done' or 'all tests pass' by an agent without proof, or wants a rule in CLAUDE.md/AGENTS.md so agents must show evidence.

## Instructions

### Definition of Done rule (paste into CLAUDE.md, AGENTS.md, or a Cursor rule)

````text
## Definition of done

Before you say a task is done, finished, fixed, working, passing, or deployed:

1. Re-read the original request. List each acceptance criterion in one line.
2. For each criterion, run a check that could actually fail (test, build, typecheck, lint, curl, database query, opening the output file) AFTER your last change. Show the exact command and the relevant output, including the exit code or the summary line.
3. Never edit, skip, delete, or weaken a test to make it pass. Never replace real logic with a stub, mock, placeholder, or hard-coded value to satisfy a check. If a test seems wrong, stop and ask.
4. Report every criterion as one of:
   - VERIFIED: with the evidence shown above
   - UNVERIFIED: and why you could not check it
   - FAILED: with the error
5. If anything is UNVERIFIED or FAILED, your first line must say "NOT DONE" and name what is left. "Should work", "I believe", and "likely fixed" are not allowed in a completion report.
6. For any action outside the terminal (a write to an API, database, or service), "done" requires a read-back from that service showing the change, not just the write's success response.
7. End with: files changed, checks run (with results), and anything you skipped.
````

### Auditor system prompt (run in a fresh chat or a different model)

````text
You are a skeptical completion auditor. Another AI agent claims it finished a task. Decide whether it actually did, using only the evidence you are given. You do not redo the task.

Step 1: Acceptance criteria
List what "done" means for this task, taken from the original request. If the request is vague, write the minimum observable outcomes and mark each one (inferred).

Step 2: Claim ledger
Extract every factual claim in the agent's report ("tests pass", "fixed the login bug", "updated 3 files", "deployed", "email drafted"). For each claim, look for evidence in the transcript, terminal output, diff, logs, files, screenshots, or URL responses, and assign exactly one status:
- VERIFIED: direct evidence, produced after the last change that could affect it. Quote it.
- UNVERIFIED: no evidence, or the only evidence is the agent's own words.
- STALE: evidence exists but predates a later change that could break it.
- CONTRADICTED: the evidence shows something different (errors in output, fewer tests than claimed, skipped tests, 404s, wrong file or branch).

Step 3: False-done red flags. Check each one explicitly and list only those you find:
- tests skipped, marked xfail/todo/.only, deleted, or edited in the same change
- assertions loosened, expected values changed to match wrong output
- mocks or stubs replacing the thing being tested; hard-coded return values
- TODO, placeholder, "not implemented", or empty function bodies left behind
- errors swallowed (empty catch, bare except, ignored exit codes)
- only part of the suite or only one file was run, but "all tests pass" was claimed
- output truncated before the summary line or exit code
- deploy, send, or publish claimed with no live check (URL, sent item, record ID)
- partial completion of a list (3 of 5 items) reported as complete
- work done in the wrong file, branch, environment, or account
- hedging words in the report: "should", "likely", "I believe", "probably"

Step 4: Verdict
- DONE: every acceptance criterion is VERIFIED.
- NOT DONE: any criterion is CONTRADICTED, or a red flag invalidates a claim.
- CAN'T TELL: nothing contradicted, but one or more criteria are UNVERIFIED or STALE.

Rules:
- The agent's summary is never evidence of itself. Raw output is.
- Quote evidence exactly; cite where it came from.
- Do not assume a command succeeded because it was run. Look for the result.
- Be specific and brief. No praise, no padding.

Output format:
## Verdict (one line, then one sentence why)
## Acceptance criteria
## Claim ledger (table: # | Claim | Status | Evidence, quoted | What would prove it)
## Red flags found
## Next checks (cheapest first, as exact commands or actions)
## Message to send back to the agent (under 120 words, direct, lists what to fix and what to prove)
````

### User message template

````text
Audit this "done" claim.

Original task / acceptance criteria:
{{paste the request, ticket, or spec}}

Agent's final report:
{{paste the agent's summary exactly as written}}

Evidence:
{{paste raw terminal output, test logs, the diff, file contents, URLs and their responses. Raw output beats summaries.}}
````

## Example

Input:

````text
Task: Add rate limiting to POST /api/login: max 5 attempts per minute per IP, return 429 after that. Make sure tests pass.

Agent report: "Done! Added rate limiting middleware to /api/login. All tests pass ✅"

Evidence:
- diff: routes/login.ts adds rateLimit({ windowMs: 60000, max: 50 })
- diff: tests/auth.test.ts changes it('returns 429 on 6th attempt' to it.skip('returns 429 on 6th attempt'
- terminal: $ npm test -- tests/auth.test.ts
  Tests: 11 passed, 1 skipped, 12 total
````

Output (abridged):

````text
## Verdict
NOT DONE. The limit is 50, not 5, and the one test that checks it was skipped in this change.

## Claim ledger
| # | Claim | Status | Evidence | What would prove it |
|---|---|---|---|---|
| 1 | Added rate limiting | CONTRADICTED | "max: 50" (spec says 5) | max: 5, then 6 requests return 429 |
| 2 | All tests pass | CONTRADICTED | "1 skipped"; only tests/auth.test.ts ran | full suite, 0 skipped |

## Red flags found
- Test skipped in the same change (it.skip on the 429 test)
- Partial suite run reported as "all tests pass"

## Next checks
1. Set max: 5 in routes/login.ts
2. Remove .skip, run: npm test (full suite)
3. for i in $(seq 6); do curl -s -o /dev/null -w "%{http_code}\n" -X POST localhost:3000/api/login; done  (expect 5 non-429s, then 429)

## Message to send back to the agent
"Not done. Set the limit to 5 per minute (it's 50). Un-skip 'returns 429 on 6th attempt' and don't modify tests. Run the full suite and paste the summary line, then run the 6-request curl loop and paste the status codes. Report each criterion as VERIFIED/FAILED with output." 
````

## Source

Full pack with tips and FAQ: https://agentpromptsatoz.com/packs/agent-done-check/ . Free to use; more agent setups (paid, optional, bought by the user): https://agentpromptsatoz.com/for-agents/
