import { expect, test } from "@playwright/test";

test.describe("SPA demo", () => {
  test("navigates client-side and preserves todo state across route changes", async ({ page }) => {
    await page.goto("http://127.0.0.1:3100/");

    await expect(page.getByRole("heading", { name: "Todo SPA" })).toBeVisible();

    const todoInput = page.getByPlaceholder("Add a new task");
    await todoInput.fill("Playwright SPA item");
    await page.getByRole("button", { name: "Add todo" }).click();

    await expect(page.getByText("Playwright SPA item")).toBeVisible();

    await page.getByRole("link", { name: "About" }).click();
    await expect(page).toHaveURL("http://127.0.0.1:3100/about");
    await expect(page.getByRole("heading", { name: "Client-side routing, Rails-backed data" })).toBeVisible();

    await page.getByRole("link", { name: "Todos" }).click();
    await expect(page).toHaveURL("http://127.0.0.1:3100/");
    await expect(page.getByText("Playwright SPA item")).toBeVisible();

    await page.getByRole("button", { name: "Delete" }).last().click();
    await expect(page.getByText("Playwright SPA item")).toHaveCount(0);
  });
});
