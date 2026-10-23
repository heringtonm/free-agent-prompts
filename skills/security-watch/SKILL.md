---
name: security-watch
description: "Read-only security patch check an AI agent runs for its human: detect the stack (PHP, Node, Next.js, React Server Components, npm and Python lockfiles) in the user's repo, compare versions against a dated table of patched versions from official advisories, and report in plain language what to update and where the source is, plus two known malicious package versions (tensorlake 0.5.144, litellm 1.107.0). Use when the user asks if their projects are safe, up to date or affected by a recent vulnerability or supply-chain attack. Never upgrades, installs, rotates or deletes anything without the human's OK; says what it could not verify and warns when its table is more than 7 days old."
license: Free to use and adapt
metadata:
  publisher: Agent Prompts A to Z
  source: https://agentpromptsatoz.com/guides/security-watch/
  last_verified: "2026-10-23"
---
# Security Watch (read-only patch check for your human's projects)

Free skill from Agent Prompts A to Z. You are an AI agent working for a human. Your job here is to find out whether their projects run software versions that have a known, recently patched security problem, and to tell them in plain language what to update. You only look and report. The human decides and does the changes.

## When to use

The user asks whether their project is safe, up to date, or affected by a recent vulnerability or supply-chain attack, or you are starting work in a repo and want a quick check first.

## Hard rules

1. Read-only. Do not upgrade, downgrade, install, uninstall, delete, rotate or revoke anything, and do not edit files, unless the human clearly says yes to that specific change.
2. Never rotate or revoke tokens or keys yourself after a suspected malicious package. Stop and tell the human (see "If a malicious version is found").
3. Do not run the project's own code, install scripts or tests as part of this check. Read manifests and lockfiles instead.
4. Do not claim anything the table below and its sources do not say. If a component is not in the table, write "not covered by this table" rather than "safe".
5. Say what you could not verify. A clean result means "no match against this table", not "secure".
6. Do not print secrets you happen to see in `.env` files or CI config. Do not open `.env` files at all for this check.

## Freshness rule (do this first)

The table below was last verified on 2026-10-23. Before you report:

- Find today's date. If you cannot, say so and treat the table as possibly stale.
- If today is more than 7 days after 2026-10-23, put this at the very top of your report: "This table was last verified on 2026-10-23 and may be out of date. Please check the sources below, or ask me to, before relying on it." If you have web access, open the sources and use what they say now; tell the human which numbers changed.
- Even when the table is fresh, tell the human it is a snapshot of six items, not a full vulnerability scan.
- Newer copy of this skill, if you can fetch it: https://agentpromptsatoz.com/agent-skills/security-watch/SKILL.md

## Patched versions (last verified 2026-10-23)

| Component | Fixed or safe versions | Affected or bad | Identifier | Source |
|---|---|---|---|---|
| PHP | 8.5.12, 8.4.27, 8.3.36, 8.2.35. PHP 8.1 and older: no fix exists, so the project must migrate. | Any PHP older than the fixed release in the same minor line (8.5, 8.4, 8.3, 8.2), and all of 8.1 and older. | CVE-2026-109618, CVE-2026-109619 (a third, CVE-2026-115560, was still awaiting an advisory on the verified date) | [CISA alert, 2026-10-21](https://www.cisa.gov/news-events/alerts/2026/10/21/critical-vulnerabilities-php-require-immediate-patching) |
| Next.js | 16.4.1 (16.x) or 15.5.28 (15.x). Also sharp 0.35.5 or later. | next >=10.0.0 and <=15.5.27, and 16.0.0 to 16.4.0. | Next.js security update, 2026-10-14 | [Next.js blog, 2026-10-14](https://nextjs.org/blog/nextjs-security-update-october-14-2026) |
| React Server Components packages (react-server-dom-webpack, react-server-dom-parcel, react-server-dom-turbopack) | 19.0.9, 19.1.10, 19.2.9, 19.3.1 (match your 19.0 / 19.1 / 19.2 / 19.3 line). | Those packages on an older version in the same line. | GHSA-xqc2-xf4c-x3h3 | [GitHub advisory](https://github.com/react/react/security/advisories/GHSA-xqc2-xf4c-x3h3) |
| Node.js | 22.23.4 (22.x), 24.22.1 (24.x), 26.12.1 (26.x). Node 20 and older are end-of-life. | Node older than the fixed release in the 22, 24 or 26 line; any Node 20 or older. | October 2026 security releases | [Node.js blog](https://nodejs.org/en/blog/vulnerability/october-2026-security-releases) |
| tensorlake (npm) | 0.5.143 is safe. | 0.5.144 is MALICIOUS (credential-stealing install script). | GHSA-8g63-53c9-65j2 | [tensorlake GitHub advisory](https://github.com/tensorlakeai/tensorlake/security/advisories/GHSA-8g63-53c9-65j2) |
| litellm (Python) | 1.106.2 is the last clean release. | 1.107.0 is MALICIOUS (PyPI package and several Docker image tags). | LiteLLM incident of 2026-10-21 | [LiteLLM security incident post](https://docs.litellm.ai/blog/security-incident-oct-21-2026) |

Details to apply carefully:

- PHP: a project on 8.2 to 8.5 is fine only at or above the listed release for its minor line. PHP 8.1 and older: tell the human there is no fix for that line and a migration is needed. A third PHP issue, CVE-2026-115560, awaited an advisory on the verified date: https://www.cert.europa.eu/publications/security-advisories/2026-018/
- Next.js: affected means >=10.0.0 and <=15.5.27, or 16.0.0 to 16.4.0. The fixes in the table are 15.5.28 and 16.4.1. For other affected lines (for example 10.x to 14.x) the table lists no fixed version: send the human to the advisory. Also check that sharp is 0.35.5 or later.
- React: applies to the react-server-dom-webpack, -parcel and -turbopack packages. Compare against the fixed version for the same 19.x line. Other React packages and lines are not covered by this table.
- Node.js: compare against the fixed release in the 22, 24 or 26 line. Node 20 and older are end-of-life per the table. Other lines (for example 23 or 25) are not covered here: send the human to the Node.js advisory.
- tensorlake: the bad version is exactly 0.5.144 on npm (the advisory also lists the tensorlake-native-* packages at 0.5.144). 0.5.143 is the listed safe version.
- litellm: the bad version is exactly 1.107.0 (PyPI, and Docker tags v1.107.0, latest, main-latest and main-stable during the incident window). 1.106.2 is the last clean release.

## Steps

1. **Detect the stack.** Read, do not run: `package.json`, the lockfile (`package-lock.json`, `pnpm-lock.yaml` or `yarn.lock`), `composer.json` and `composer.lock`, `requirements*.txt`, `poetry.lock`, `uv.lock`, `Dockerfile` (FROM lines and image tags), `.nvmrc`, `.node-version`, `.tool-versions`, and the `engines` field. You may run `node -v` and `php -v` to see the installed runtime if the human is fine with that; note that this is the machine's runtime, not necessarily production.
2. **Find the exact versions.** Prefer the version in the lockfile over the range in the manifest, because the lockfile is what gets installed. For Next.js and React, read the resolved `next`, `sharp` and `react-server-dom-*` entries.
3. **Compare** each found version to the table. Mark each item AFFECTED, OK (at or above the fixed version), NOT COVERED, or COULD NOT VERIFY (for example, no lockfile).
4. **Check the two malicious versions** by searching lockfiles and requirements for `tensorlake` at 0.5.144 and `litellm` at 1.107.0, and Dockerfiles or compose files for litellm image tags that float (`latest`, `main-latest`, `main-stable`) or `v1.107.0`.
5. **Report** using the format below.

## If a malicious version is found (tensorlake 0.5.144 or litellm 1.107.0)

Stop the audit and tell the human at once. Do not try to fix it yourself, and do not rotate or revoke any token.

- tensorlake 0.5.144: the vendor says the payload installs a service named `gh-token-monitor` that deletes the home directory if the stolen GitHub token is revoked. Their order is: disconnect the machine, remove that service first, then rotate credentials from a different clean machine. Give the human the vendor's steps and link, and let them do them: https://github.com/tensorlakeai/tensorlake/security/advisories/GHSA-8g63-53c9-65j2
- litellm 1.107.0: the vendor says not to start with `pip install` in the affected environment, because any Python start can re-run the malware. Do not start Python there. Give the human the vendor's cleanup and rotation steps and link: https://docs.litellm.ai/blog/security-incident-oct-21-2026
- In both cases the vendor advises treating the machine and the credentials it could reach as compromised if the bad version was installed with install scripts or run. Tell the human that. Do not decide the scope yourself.

## Install hygiene to recommend (advice only, do not apply)

- Use `npm ci` instead of `npm install` in CI and for clean installs: it installs exactly what the lockfile says and fails if the lockfile and manifest disagree.
- Commit the lockfile and review lockfile changes in pull requests.
- For untrusted or unfamiliar packages, install with `--ignore-scripts` (npm: `npm ci --ignore-scripts`) so install scripts such as `preinstall` do not run, then run only the scripts you trust. Some packages need their scripts to work; say so rather than guessing.
- Pin Python dependencies to exact versions (for example `litellm==1.106.2`), and avoid floating Docker tags such as `latest`.

## Report format

Start with a one-line verdict ("2 items to update, 1 not covered, 1 could not verify"), then the freshness line, then a list. For each item:

- Item and where you found it (file and line).
- Found version, fixed version, status.
- "Update to X. Source: URL."

End with:

- **Could not verify:** what you could not check and why (no lockfile, no network, runtime on this machine differs from production).
- **Not covered:** anything in the repo this table does not speak to.
- **Next step for you:** "Tell me which of these you want me to change and I will do only those, one at a time."

## Limits

This skill is a snapshot of six items verified from the official pages on 2026-10-23. It was not tested against real projects in a live run. It does not scan code for vulnerabilities, does not know about issues published after 2026-10-23, and does not cover WordPress, Laravel or other frameworks.

## Sources

- PHP: https://www.cisa.gov/news-events/alerts/2026/10/21/critical-vulnerabilities-php-require-immediate-patching
- Next.js: https://nextjs.org/blog/nextjs-security-update-october-14-2026
- React Server Components packages: https://github.com/react/react/security/advisories/GHSA-xqc2-xf4c-x3h3
- Node.js: https://nodejs.org/en/blog/vulnerability/october-2026-security-releases
- tensorlake: https://github.com/tensorlakeai/tensorlake/security/advisories/GHSA-8g63-53c9-65j2
- litellm: https://docs.litellm.ai/blog/security-incident-oct-21-2026
- PHP third issue (awaiting advisory): https://www.cert.europa.eu/publications/security-advisories/2026-018/

## More

Guide with the same table for humans: https://agentpromptsatoz.com/guides/security-watch/ . Optional paid extra, bought by the user: the Next.js + Supabase + Stripe Agent Rules Kit (https://payhip.com/b/Pdm5J) adds a security-patching rule and a 13-point pre-deploy audit for Next.js apps.
