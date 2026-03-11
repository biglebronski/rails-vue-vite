import { expect, test } from "@playwright/test";

test.describe("HTML demo", () => {
  test("keeps Rails routing while persisting widget changes through the server", async ({ page }) => {
    await page.goto("http://127.0.0.1:3101/");

    await expect(page.getByRole("heading", { name: "HTML-first demo" })).toBeVisible();

    const todoInput = page.getByPlaceholder("Add an item");
    await todoInput.fill("Playwright HTML item");
    await page.getByRole("button", { name: "Add" }).click();

    await expect(page.getByText("Playwright HTML item")).toBeVisible();

    await page.reload();
    await expect(page.getByText("Playwright HTML item")).toBeVisible();

    await page.getByRole("link", { name: "About" }).click();
    await expect(page).toHaveURL("http://127.0.0.1:3101/about");
    await expect(page.getByRole("heading", { name: "About the HTML-first mode" })).toBeVisible();

    await page.goBack();
    await expect(page).toHaveURL("http://127.0.0.1:3101/");
    await expect(page.getByText("Playwright HTML item")).toBeVisible();
  });
});
