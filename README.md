# Asuna

SDET agent + skills for **Cursor** and **Claude Code**. Drop it into any TypeScript project that uses Playwright, Vitest, or both.

Asuna writes tests in the host repo's existing style. It does not invent a parallel framework.

## Should this repo be public?

Yes, if other people should be able to install it. A public repo means a one-line install works without a GitHub invite. There are no secrets here — only agent instructions and a MIT license.

## Install

Pick one.

### This project (share with the team)

From the project root:

```bash
curl -fsSL https://raw.githubusercontent.com/memospeam/asuna/main/install.sh | bash
```

Then commit `.cursor/` and `.claude/` so everyone on the repo gets Asuna.

### This machine (every project)

```bash
curl -fsSL https://raw.githubusercontent.com/memospeam/asuna/main/install.sh | bash -s -- --global
```

Copies into `~/.cursor/` and `~/.claude/`. No per-repo commit needed.

### Already cloned

```bash
./install.sh /path/to/your-project
./install.sh --global
```

Existing files are skipped. Add `--force` to overwrite. Add `--templates` on a project install to also drop a Playwright 2-layer POM scaffold (skipped if `e2e/` already exists).

### Skills CLI (skills only)

```bash
npx skills add memospeam/asuna --all -y
npx skills add memospeam/asuna --all -g -y   # user-wide
```

This installs the skills, not the `@asuna` agent file. Prefer `install.sh` if you want both.

## After install

In Cursor, start a new chat and mention **asuna** (or `@asuna`):

```
@asuna เพิ่ม test สำหรับหน้า login
@asuna plan coverage จากลิสต์นี้
@asuna ทำไมเคสนี้ fail
```

| Skill | Use when |
|-------|----------|
| `asuna-tests` | Add or edit tests |
| `asuna-plan` | Plan coverage before coding |
| `asuna-iterate` | Run cases one by one |
| `asuna-debug` | A test is red or flaky |
| `asuna-review` | Review a test diff / PR |
| `asuna-run` | Run the suite |

## How Asuna picks a stack

It reads the **host** project. Nothing here is Pokémon- or SET-specific.

1. `playwright.config.*` or `e2e/` → Playwright POM
2. `vitest.config.*` or colocated `*.test.ts` → Vitest
3. Both → follow what you asked for; otherwise copy the neighbouring test

Core rule: **ห้ามคาดเดา** — read the implementation and sibling tests before writing. If source does not answer, ask.

## Layout

```
agents/asuna.md              # Cursor + Claude agent
skills/asuna-tests/          # conventions + workflow
skills/asuna-plan/
skills/asuna-iterate/
skills/asuna-debug/
skills/asuna-review/
skills/asuna-run/
templates/playwright/        # optional POM starter
install.sh
```

Host-project specifics (routes, helpers, APIs) stay in the host repo.
