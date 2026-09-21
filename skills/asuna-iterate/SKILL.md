---
name: asuna-iterate
description: >-
  Run test cases one by one — add test.only / it.only or use -g / -t, run,
  verify pass/fail, remove .only, advance. Use when the user says
  "รันทีละ case", "ใส่ it.only ทีละข้อ", "รันเคสนี้ก่อน".
---

# Iterative case-by-case runs

## Run-one pattern

1. Identify the next `test("…")` / `it("…")`.
2. Prefer **no file edit**:
   - Playwright: `npx playwright test <file> -g "<unique substring>"`
   - Vitest: `npx vitest run <path> -t "<unique substring>"`
3. If the filter is too broad, temporarily `test.only` / `it.only`.
4. **Pass** → remove `.only` immediately, go to the next case.
5. **Fail** → fix (or `asuna-debug`), re-run before advancing.

### Rules

- At most one `.only` in the repo. Never commit `.only`.
- Do not raise timeouts as the first fix.
- Use host npm scripts when they exist.

## Inspect pattern

- Playwright: trace viewer / `page.screenshot` only while debugging; delete before commit.
- Vitest: temporary `console.log` of the relevant slice; delete before commit.

## Failure handling

| Failure | Next step |
|---------|-----------|
| Locator / timeout | Read the component; selector may be wrong |
| Assertion mismatch | Read source — expectation may be stale |
| Network | Check whether sibling tests stub the API |
| import / TS error | Typecheck, then fix types; don't skip the test |
