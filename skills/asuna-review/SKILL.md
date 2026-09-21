---
name: asuna-review
description: >-
  Review an EXISTING test change (diff / PR / working tree) against host
  conventions, then verify by running the affected files. Use when the user
  asks to "review this test", "ตรวจ PR", "เขียนถูก convention ไหม".
---

# Reviewing test changes

## 1. Get the diff

```bash
git diff
git diff main...HEAD -- "*.spec.ts" "*.test.ts"
```

Read changed test files in full when the diff is large.

## 2. Checklist

- [ ] File lives where the host already puts that kind of test.
- [ ] Playwright specs import `test` from the fixture, not `@playwright/test`.
- [ ] POM methods assert themselves; selectors live in `SELECTOR`.
- [ ] Vitest helpers are file-local and match sibling style.
- [ ] No invented selectors / return shapes — matches source.
- [ ] No leftover `.only` / debug `console.log` / `waitForTimeout`.
- [ ] No new test framework.
- [ ] Diff is focused (no unrelated reformat).
- [ ] Titles are specific enough to filter with `-g` / `-t`.

## 3. Verify

Run the changed files with the host command. State what you actually ran.

## 4. Output

- **Must fix** — convention breaks, leftover `.only`, red tests.
- **Should fix** — vague titles, duplicated setup a sibling already has.
- **Nits** — style.
- Verdict: ready / changes needed.
