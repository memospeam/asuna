import { Page, expect } from "@playwright/test";

export class CommonPage {
  public readonly page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  private readonly SELECTOR = {
    app: '[data-testid="app"]',
  };

  get app() {
    return this.page.locator(this.SELECTOR.app);
  }

  async gotoHome() {
    await this.page.goto("/");
    await expect(this.page).toHaveURL(/\/$/);
  }
}
