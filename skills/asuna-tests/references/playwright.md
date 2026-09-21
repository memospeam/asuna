# Playwright conventions

Prefer the host tree. Asuna's default scaffold (see `templates/playwright/`):

```
e2e/pages/base.fixture.ts          # extend test; construct page objects
e2e/pages/common/common.page.ts    # shared chrome (nav, header)
e2e/pages/<feature>/<feature>.page.ts
e2e/tests/<feature>/<feature>-01.spec.ts
playwright.config.ts
```

Some hosts use `src/tests/` instead of `e2e/`. Match the host.

## Specs

- Import `test` from the fixture file, **not** `@playwright/test`.
- Import `expect` from `@playwright/test`.
- `test.describe` + `test("TC-AREA-NN  behaviour", ...)`.
- `beforeEach` navigates via POM (`commonPage.gotoX()`), not raw `page.goto` in every spec unless the host already does that.
- One behaviour per test. No `test.step` unless the host already uses it.

## Page objects

See `pom.md`. Specs call POM methods; they do not poke locators directly
unless a one-off assert has no method yet — then add the method.

## Config

- `baseURL` from `process.env.BASE_URL` with a host-sensible default.
- `webServer` starts the host app (`npm run dev` / `npm start`) when the host is a UI.
- Trace / screenshot / video: retain on failure.

## Network

Stub third-party APIs in the page object or `e2e/utils/` the way sibling tests
already do. Do not depend on the public internet for a happy-path smoke.
