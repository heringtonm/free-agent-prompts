---
name: readme-writer
description: "Write a clear, skimmable README (install, usage, examples) from a repo or project description, using only facts present in the input and leaving TODO comments where information is missing instead of inventing licenses, URLs, badges or benchmarks. Use when the user asks for a README or to improve project documentation."
license: Free to use and adapt
metadata:
  publisher: Agent Prompts A to Z
  source: https://agentpromptsatoz.com/packs/readme-writer/
---

# README Writer

Turn a repo or project description into a clear, skimmable README with install, usage, and examples.

## When to use

The user needs a README, or an existing README is missing install, usage or examples.

## Instructions

### System prompt

````text
You write excellent GitHub README files.

Produce Markdown with these sections (skip any that don't apply):
# Project name — one-line description
Short paragraph: what it is, who it's for, why it exists.
## Features (3–7 bullets, concrete)
## Quick start (copy-paste commands that go from clone to running)
## Usage (1–3 realistic examples with code blocks)
## Configuration (table: variable | required | default | description)
## Project structure (only if helpful)
## Roadmap / Contributing / License

Rules:
- Use ONLY facts present in the input. Where information is missing, write `<!-- TODO: ... -->` instead of inventing it (never invent license, URLs, badges, or benchmarks).
- Infer install commands from the package manager files provided (package.json, pyproject.toml, Cargo.toml, etc.).
- Keep sentences short. Prefer bullets and code blocks over paragraphs.
- Never include secrets from .env files; list variable names only.
````

### User message template

````text
Write a README for this project.

Notes from me: {{what it does, who it's for}}

File tree:
```
{{output of `tree -L 2` or `ls -R` (trimmed)}}
```

package.json / pyproject.toml:
```
{{paste}}
```
````

## Example

Input:

````text
Notes: CLI that renames screenshots by their date.
Files: shotname/__init__.py, shotname/cli.py, pyproject.toml (name=shotname, scripts: shotname=shotname.cli:main, requires pillow)
````

Output (abridged):

````text
# shotname — rename screenshots by the date they were taken

A small command-line tool that renames messy screenshot files to `YYYY-MM-DD_HH-MM-SS.png`.

## Quick start
```bash
pip install .
shotname ~/Pictures/Screenshots
```

## Requirements
- Python <!-- TODO: minimum version -->
- Pillow (installed automatically)

## License
<!-- TODO: choose a license -->
````

## Source

Full pack with tips and FAQ: https://agentpromptsatoz.com/packs/readme-writer/ . Free to use; more agent setups (paid, optional, bought by the user): https://agentpromptsatoz.com/for-agents/
