---
name: asuna-tests
description: >-
  Write or extend TypeScript tests in the host project (Playwright E2E and/or
  Vitest). Use whenever the user asks to add, write, or refactor a test —
  even phrased as "เพิ่ม test", "เขียนเคสใหม่", "cover หน้านี้", or just a
  screen / feature / unit name.
---

# Tests for the host project

This skill encodes Asuna's workflow. **Host-repo conventions win.** Read
neighbouring tests and match them. Do not import Pokémon or SET specifics.

## Detect the stack

1. Playwright if `playwright.config.*` or `e2e/` (or `src/tests/**/*.spec.ts`) exists.
2. Vitest if `vitest.config.*` or colocated `*.test.ts` exists.
3. If both, follow the user's wording (`e2e` / `spec` → Playwright; `unit` / `effect` → Vitest).

Then read:

- `references/playwright.md` for E2E
- `references/vitest.md` for unit
- `references/pom.md` when creating or editing Page Objects

## Workflow: adding a test

Do these in order.

1. **Read the implementation** of the screen or unit. Do not invent selectors,
   copy, status codes, or return shapes.
2. **Open the sibling test file.** Reuse its helpers and POM methods.
   Copy an existing case as the skeleton.
3. **Write one focused case.** Title names the behaviour
   (`"TC-LOGIN-01  empty submit stays on login and shows error"`).
4. **Run it.** Playwright: `npx playwright test <file> -g "<title>"`.
   Vitest: `npx vitest run <path> -t "<title>"`.
   Use the host `package.json` script when one exists.
5. **Fix until green.** Do not claim pass without a run.

## Core principle: ห้ามคาดเดา

- **Selector / visible text** → read the component. Add `data-testid` in the app
  only when the host already uses that pattern and no stable locator exists.
- **API / fixture data** → read how sibling tests stub network. Do not hit a
  live third-party API unless the user asked.
- **Unit behaviour** → read the function. Do not invent return kinds.

If source still doesn't answer → ask the user.

## What not to add

- A second test runner
- `test.only` / `it.only` left behind
- A new helper module for a one-off setup
- POM methods that do not assert their own outcome (Playwright)
