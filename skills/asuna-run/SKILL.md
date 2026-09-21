---
name: asuna-run
description: >-
  Execute the host test suite — full run, one file, or one name filter.
  Use when the user wants to RUN tests (not diagnose): "run the tests",
  "รัน test", "รันไฟล์นี้". (To WRITE tests use asuna-tests; to DIAGNOSE
  use asuna-debug.)
---

# Running tests

You **can** run tests locally. Run them. Do not claim pass/fail you didn't execute.

## Discover commands

Read `package.json` scripts (`test`, `test:e2e`, `test:unit`). Use those.

Fallbacks:

```bash
npx playwright test
npx playwright test <file> -g "<title>"
npx vitest run
npx vitest run <path> -t "<title>"
npm test
```

Do not run slow / corpus / report scripts unless asked — if `vitest.config`
excludes them, leave them excluded.

## After a background run

Read the reporter output. If you used `.only`, remove it. Kill leftover watch
processes if you accidentally started a watcher.
