---
name: asuna-plan
description: >-
  Turn a feature list, gap list, or informal test note into a structured
  automation plan before any code is written. Use when the user shares a list
  of screens/cases, or says "plan coverage", "วิเคราะห์ TC", "มีเคสใหม่".
---

# Coverage plan (no code yet)

Read the input, map each item to an existing test file, and hand the plan to
the user. Asuna writes tests only after they approve.

## Step 1 — Read the input

Accept a file path, pasted table, or screen names. For each item extract:
id/name, behaviour, and whether it is UI (Playwright) or unit (Vitest).

## Step 2 — Classify

Look at the host tree. Map to an existing spec/test file. If none exists, the
plan should say **new file next to the existing convention** (e.g. new
`e2e/tests/<feature>/` or new colocated `*.test.ts`).

## Step 3 — Action per item

| Action | When |
|--------|------|
| **Add a case to existing file** | Feature already has a describe |
| **New test file** | No sibling |
| **POM + spec pair** | New screen with no page object |
| **Manual / skip** | Visual-only, captcha, or needs a human |

## Step 4 — Output

```
## Automation Plan

| ID | Behaviour | File | Action | Complexity | Notes |
|----|-----------|------|--------|------------|-------|

### Questions before coding
- [ ] Playwright vs Vitest for each item
- [ ] Priority order if not all items land in one pass
```

Complexity: **Low** = one case; **Medium** = new file reusing POM/helpers;
**High** = new helper + product gap (test cannot pass yet).

## Step 5 — Handoff

After approval, one item (or a small batch) at a time:

> เขียน: เพิ่มเคสใน `<file>` — scenario: …, assert: …

Do not dump the raw backlog at asuna — distil it first.
