# RailsVueVite

`rails_vue_vite` is a Rails 7+ gem for wiring Vue and Vite into Rails with a small Rails-side API, generator support, and test coverage around the integration points that usually break.

Two demo apps live in this repo:

- `test/dummy_spa`: Rails serves an SPA shell and `/api/*`, Vue Router owns the page
- `test/dummy_html`: Rails owns routing and HTML, Vue mounts as an island/widget

## Goals

- Rails 7+ compatibility through `railties`
- Small helper API for Vite client, JS, and CSS tags
- Predictable production manifest resolution
- Generator-backed setup for a new Rails app
- CI built around a Rails matrix so breakage is caught quickly

## Requirements

- Ruby 3.2+
- Rails 7.0+
- Node.js and npm

## Install In An Existing Rails 7+ App

Until this gem is published, point your Rails app at a local checkout.

### 1. Add the gem

If you downloaded or cloned this repo locally, you can reference it directly from your app.
Putting it under `vendor/` is fine, but not required. Any stable local path works.

Example using a checkout in `vendor/rails-vue-vite`:

```ruby
gem "rails_vue_vite", path: "vendor/rails-vue-vite"
```

Example using a checkout elsewhere on disk:

```ruby
gem "rails_vue_vite", path: "/absolute/path/to/rails-vue-vite"
```

When the gem is published later, this becomes:

```ruby
gem "rails_vue_vite"
```

Then install gems:

```sh
bundle install
```

### 2. Generate the starter files

If your app does not already have a `package.json`, the generator will create one with the required Vue/Vite dependencies and scripts.
If your app already has a `package.json`, the generator will not modify it.

For the standard HTML-first setup:

```sh
bin/rails generate rails_vue_vite:install
```

For the SPA setup:

```sh
bin/rails generate rails_vue_vite:install --spa
```

That generator creates:

- `config/initializers/rails_vue_vite.rb`
- `vite.config.ts`
- `config/vite.json`
- `package.json` with Vite scripts and Vue dependencies if one does not already exist
- `app/frontend/entrypoints/application.js`
- SPA-only scaffolding when `--spa` is used

### 3. Install frontend packages

If `package.json` does not exist, the generator creates one.
If `package.json` already exists, the generator leaves it alone and prints a message telling you to configure it manually.

The generator does not run your package manager for you.

Run:

```sh
npm install
```

### 4. Start Rails and Vite

Run these in separate terminals:

```sh
bin/rails server
```

```sh
npm run dev
```

### 5. Render Vite tags from Rails

Use the helpers in your layout or page:

```erb
<%= vite_client_tag %>
<%= vite_stylesheet_tag "application" %>
<%= vite_javascript_tag "application" %>
```

Generated configuration lives in `config/initializers/rails_vue_vite.rb`.

## Recommended Usage Patterns

### HTML-First Rails Mode

Use this when:

- Rails should own routing and page rendering
- full page reloads are acceptable
- Vue should enhance part of a page instead of owning the whole app

Typical layout:

```erb
<%= vite_client_tag %>
<%= vite_javascript_tag "application" %>
```

Typical page:

```erb
<section>
  <h1>Server-rendered page</h1>
</section>

<section data-vue-widget></section>
```

Typical entrypoint:

```js
import { createApp } from "vue";
import Widget from "../widgets/Widget.vue";

document.addEventListener("DOMContentLoaded", () => {
  const element = document.querySelector("[data-vue-widget]");
  if (!element) return;

  createApp(Widget).mount(element);
});
```

### SPA Mode

Use this when:

- Rails should serve the initial shell and APIs
- Vue Router should own user-facing navigation after boot
- the full page layout should live in Vue

Recommended SPA boundary:

- Rails serves the initial shell and JSON endpoints under `/api/*`
- Vue Router owns all user-facing navigation after boot
- the Rails shell view renders one mount node, not partial page chrome
- header, footer, nav, and route content all live in Vue

Typical Rails routes:

```ruby
namespace :api do
  resources :todos, only: [:index, :create, :destroy]
end

get "/up" => "rails/health#show", as: :rails_health_check
root "spa#index"
get "*path", to: "spa#index", constraints: ->(request) { !request.xhr? && request.format.html? }
```

Typical SPA controller:

```ruby
class SpaController < ActionController::Base
  def index
    render :index
  end
end
```

Typical shell view:

```erb
<%= vite_client_tag %>
<%= vite_javascript_tag "application" %>

<div id="app"></div>
```

Typical entrypoint:

```js
import { createApp } from "vue";
import App from "../App.vue";
import router from "../router";

createApp(App).use(router).mount("#app");
```

## Frontend Dependencies In User Apps

Users can add normal npm packages the same way they would in any Vite app:

```sh
npm install axios pinia dayjs
```

Then import them from `app/frontend/...`:

```js
import axios from "axios";
import { createPinia } from "pinia";
```

The gem should stay focused on Rails integration. Your app still owns its frontend dependencies.

## Running The Demo Apps

### SPA Demo

This demo lives at `test/dummy_spa`.

It shows:

- Rails catch-all shell routing
- `/api/todos`
- Vue Router handling `Todos` and `About`
- the full page layout rendered by Vue

Install dependencies:

```sh
bin/setup-demo-spa
```

Run in two terminals:

```sh
bin/dev-demo-spa-rails
```

```sh
bin/dev-demo-spa-vite
```

Then open:

```text
http://localhost:3000
```

Vite runs on port `5173` for this demo.
The Vite launcher script prefers an `nvm`-managed Node when one is installed so background task runners do not accidentally boot an older system Node.

### HTML Demo

This demo lives at `test/dummy_html`.

It shows:

- standard Rails routing for Home/About
- Rails-rendered pages
- a Vue todo widget mounted only on the home page

Install dependencies:

```sh
bin/setup-demo-html
```

Run in two terminals:

```sh
bin/dev-demo-html-rails
```

```sh
bin/dev-demo-html-vite
```

Then open:

```text
http://localhost:3000
```

Vite runs on port `5174` for this demo.
The Vite launcher script prefers an `nvm`-managed Node when one is installed so background task runners do not accidentally boot an older system Node.

## Production Build And Deploy

Development and production work differently on purpose.

### Development

In development:

- `vite_client_tag` and `vite_javascript_tag` point to the Vite dev server
- assets are served from `http://localhost:5173` or your configured dev server URL
- hot module reload is active
- no manifest lookup is needed

Typical workflow:

```sh
bin/rails server
npm run dev
```

### Production

In production:

- Vite builds fingerprinted assets into `public/vite`
- Vite writes a manifest to `public/vite/.vite/manifest.json`
- `rails_vue_vite` reads that manifest and emits the built asset paths
- Rails serves the compiled static assets instead of talking to a dev server

This is manifest-driven, not `dist/index.js`-driven.

The helper flow is:

1. resolve an entrypoint like `"application"`
2. look it up in `public/vite/.vite/manifest.json`
3. emit the hashed asset path, such as `/vite/assets/application-abc123.js`

### What You Need To Do

Before deploying, build the frontend:

```sh
npm run build
```

Your deploy must include:

- `public/vite`
- `public/vite/.vite/manifest.json`

Your Rails app configuration must match the build output:

- `config.public_output_dir`
- `config.build_output_dir`
- `config.manifest_path`

The defaults generated by this gem are:

```ruby
config.public_output_dir = "vite"
config.build_output_dir = File.join("public", config.public_output_dir)
config.manifest_path = File.join(config.build_output_dir, ".vite", "manifest.json")
```

### Why Production Is Different

Development optimizes for:

- fast rebuilds
- hot reload
- a separate asset server

Production optimizes for:

- fingerprinted asset filenames
- cacheable static files
- deterministic asset lookup through the manifest

### Production Checklist

- run `npm install`
- run `npm run build`
- confirm `public/vite/.vite/manifest.json` exists
- confirm built assets exist under `public/vite`
- deploy the built assets with the Rails app
- ensure Rails serves static files correctly in your production environment

## API Reference

### Helpers

- `vite_client_tag`
- `vite_javascript_tag(*entrypoints, **options)`
- `vite_stylesheet_tag(*entrypoints, **options)`

### Configuration

Generated in `config/initializers/rails_vue_vite.rb`.

Main options:

- `config.mode`
- `config.dev_server_url`
- `config.source_code_dir`
- `config.entrypoints_dir`
- `config.public_output_dir`
- `config.build_output_dir`
- `config.manifest_path`
- `config.spa_mode`
- `config.spa_entrypoint`
- `config.spa_mount_path`

## Development

Run the gem tests plus both demo app integration tests:

```sh
bundle exec rake
```

For Rails matrix testing:

```sh
bundle exec appraisal install
bundle exec appraisal rake
```

For browser-level smoke tests against both demo apps:

```sh
npm install
npx playwright install
npm run test:e2e
```

GitHub Actions uploads Ruby coverage artifacts from the gem and both demo apps, and runs Playwright smoke tests against the SPA and HTML demos.

## Current Scope

This project currently covers:

- Rails view helpers
- configuration
- production manifest loading
- install generator
- SPA demo app
- HTML-first demo app

Still to improve:

- fuller install automation for user app `package.json`
- stronger release and maintenance automation

## Roadmap

1. Stabilize the Rails/Vite/Vue integration surface for early adopters.
2. Prove the SPA and HTML-first patterns in more real-world apps.
3. Improve install and production deploy ergonomics.
4. Expand compatibility based on real user feedback.
