# Vitest conventions

Follow the **host**:

| Host pattern | Keep doing that |
|--------------|-----------------|
| Colocated `foo.ts` → `foo.test.ts` | Do not add `__tests__/` |
| `__tests__/` or `src/**/*.spec.ts` | Do not switch to colocated |
| `import { describe, expect, it } from "vitest"` | Match imports |
| Path alias `@/` | Use it only if neighbours do |

## Shape

- `describe("unit under test")` + `it("behaviour")`.
- Helpers stay **file-local** until two files share the same 20+ line setup
  **and** the user asked to extract.
- Prefer `toEqual` for exact values; `toMatchObject` / `toContain` when siblings already do.
- Pin RNG / clocks / seeds when the unit is non-deterministic.

## Commands

```bash
npx vitest run
npx vitest run <path>
npx vitest run <path> -t "<title>"
```

Read `vitest.config.*` for excludes (slow corpus, e2e). Do not run excluded
jobs unless the user asked.

## What not to mix in

- Playwright imports in a unit file
- Testing Library unless the host already uses it for that component
