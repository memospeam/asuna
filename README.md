# Asuna

SDET agent + skills for Cursor and Claude Code. Install into any TypeScript project that uses **Playwright**, **Vitest**, or both.

Asuna writes and edits tests in the host repo's existing style. It does not invent a parallel framework.

## Install

From this repo:

```bash
./install.sh /path/to/your-project
```

From GitHub without cloning first:

```bash
git clone git@github.com:memospeam/asuna.git /tmp/asuna
/tmp/asuna/install.sh /path/to/your-project
```

Copies:

| Source | Destination |
|--------|-------------|
| `agents/asuna.md` | `.cursor/agents/asuna.md` and `.claude/agents/asuna.md` |
| `skills/asuna-*` | `.cursor/skills/` and `.claude/skills/` |

Existing files are skipped. Use `--force` to overwrite.

Optional Playwright 2-layer POM scaffold (does not overwrite existing `e2e/`):

```bash
./install.sh --templates /path/to/your-project
```

Then in Cursor, mention **asuna** (or `@asuna`) when you want tests written.

## What you get

| Skill | Use when |
|-------|----------|
| `asuna-tests` | Add or edit tests |
| `asuna-plan` | Plan coverage before coding |
| `asuna-iterate` | Run cases one by one |
| `asuna-debug` | A test is red or flaky |
| `asuna-review` | Review a test diff / PR |
| `asuna-run` | Run the suite |

## Stack detection

On install into a host project, Asuna reads that project:

1. `playwright.config.*` or `e2e/` → Playwright POM
2. `vitest.config.*` or colocated `*.test.ts` → Vitest
3. Both → use the stack the user named; default to existing neighbouring tests

Core rule: **ห้ามคาดเดา** — read the implementation and sibling tests before writing. If source does not answer, ask.

## Layout of this repo

```
agents/asuna.md
skills/asuna-tests/          # conventions + workflow
skills/asuna-plan/
skills/asuna-iterate/
skills/asuna-debug/
skills/asuna-review/
skills/asuna-run/
templates/playwright/        # optional 2-layer POM starter
install.sh
```

Host-project specifics (routes, helpers, card names, APIs) stay in the host repo, not here.
