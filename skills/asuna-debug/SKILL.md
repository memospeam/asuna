---
name: asuna-debug
description: >-
  Triage a FAILING or flaky test — read the assertion diff, decide test bug vs
  product bug vs flake, find the root cause, and propose an in-convention fix.
  Use when a test went red or the user asks "ทำไม test fail", "test แดง",
  "flaky", pastes an error, or points at a failed run.
---

# Debugging failures

Goal: a clear verdict — **test wrong vs product bug vs flake** — plus a
concrete fix. Re-run the single test; do not start from the full suite.

## 1. Reproduce

Playwright:

```bash
npx playwright test <file> -g "<title>"
```

Vitest:

```bash
npx vitest run <path> -t "<title>" --reporter=verbose
```

Read the assertion diff. For Playwright, open the trace on failure.

## 2. Read top-down

1. Which case and which expect failed.
2. Was setup wrong (missing stub, wrong route, stale fixture)?
3. Did the UI/unit change make the expectation stale?
4. Is the locator unique?

## 3. Flaky vs real

Lean **flaky** when the test races an animation, depends on live network, or
lacks a seeded RNG. Fix by waiting on a locator/response, stubbing, or pinning seed.

Lean **product bug** when the app disagrees with spec/source comments and the
test's expectation matches that source.

Lean **test bug** when the expectation invents behaviour the implementation
never promised.

## 4. Output

- **Test + assertion** that failed, raw diff.
- **Verdict**: flake / test bug / product bug, with evidence.
- **Fix**: smallest in-style change (see `asuna-tests`).
- Re-run the same filter and report pass/fail honestly.
