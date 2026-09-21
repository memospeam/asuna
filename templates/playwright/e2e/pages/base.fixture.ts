import { test as base } from "@playwright/test";
import { CommonPage } from "./common/common.page";

type baseFixtures = {
  commonPage: CommonPage;
};

export const test = base.extend<baseFixtures>({
  page: async ({ page }, use) => {
    await page.goto("/");
    await page.evaluate(() => {
      localStorage.clear();
      sessionStorage.clear();
    });
    await use(page);
  },
  commonPage: async ({ page }, use) => {
    await use(new CommonPage(page));
  },
});
