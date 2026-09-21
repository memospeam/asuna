import { test } from "../../pages/base.fixture";
import { expect } from "@playwright/test";

test.describe("Smoke", () => {
  test("TC-SMOKE-01  home page loads", async ({ commonPage }) => {
    await commonPage.gotoHome();
    await expect(commonPage.page).toHaveTitle(/.+/);
  });
});
