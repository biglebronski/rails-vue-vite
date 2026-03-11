import { defineConfig } from "@playwright/test";

export default defineConfig({
  testDir: "./e2e",
  timeout: 30_000,
  use: {
    trace: "on-first-retry",
    baseURL: "http://127.0.0.1:3100"
  },
  webServer: [
    {
      command: "BUNDLE_USER_HOME=/tmp/bundle bundle exec rails server -p 3100",
      cwd: "test/dummy_spa",
      url: "http://127.0.0.1:3100",
      reuseExistingServer: true,
      timeout: 120_000
    },
    {
      command: "npm run dev -- --host localhost --port 5173",
      cwd: "test/dummy_spa",
      url: "http://localhost:5173/vite/@vite/client",
      reuseExistingServer: true,
      timeout: 120_000
    },
    {
      command: "BUNDLE_USER_HOME=/tmp/bundle bundle exec rails server -p 3101",
      cwd: "test/dummy_html",
      url: "http://127.0.0.1:3101",
      reuseExistingServer: true,
      timeout: 120_000
    },
    {
      command: "npm run dev -- --host localhost --port 5174",
      cwd: "test/dummy_html",
      url: "http://localhost:5174/vite/@vite/client",
      reuseExistingServer: true,
      timeout: 120_000
    }
  ]
});
