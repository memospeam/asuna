# 2-layer Page Object Model

Layer 1 — locators + self-asserting actions.
Layer 2 — specs that only arrange, call POM, and assert the outcome.

## Class shape

```ts
export class FeaturePage {
  constructor(public readonly page: Page) {}

  private readonly SELECTOR = {
    root: '[data-testid="feature-root"]',
    submit: '[data-testid="feature-submit"]',
  };

  get root() {
    return this.page.locator(this.SELECTOR.root);
  }
  get submit() {
    return this.page.locator(this.SELECTOR.submit);
  }

  async verifyVisible() {
    await expect(this.root).toBeVisible();
  }

  async clickSubmit() {
    await this.submit.click();
    await expect(this.page).toHaveURL(/\/next/);
  }
}
```

## Rules

- Selectors live in one `SELECTOR` object. No locator strings in methods.
- Getters return locators. Methods perform an action **and** assert the result.
- Prefer `data-testid`. Fall back to role / label. Avoid CSS-class chains and nth-of-type.
- Shared chrome (nav, login shell) belongs in `common.page.ts`.
- Feature pages may compose `CommonPage`.
- Fixture constructs every page object and exports `test`.

## Do not

- Put waits like `page.waitForTimeout` in POM.
- Return raw data from a method that should have asserted it.
- Duplicate a sibling method "just in case."
