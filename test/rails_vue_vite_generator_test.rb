# frozen_string_literal: true

require "test_helper"
require "generators/rails_vue_vite/install_generator"

class RailsVueViteGeneratorTest < Rails::Generators::TestCase
  tests RailsVueVite::Generators::InstallGenerator
  destination File.expand_path("tmp/generator", __dir__)
  setup :prepare_destination
  setup :create_routes_file

  def test_generator_creates_initializer_and_frontend_files
    run_generator

    assert_file "config/initializers/rails_vue_vite.rb" do |content|
      assert_includes content, "RailsVueVite.configure"
      assert_includes content, "config.spa_mode = false"
    end

    assert_file "vite.config.ts" do |content|
      assert_includes content, "@vitejs/plugin-vue"
    end

    assert_file "config/vite.json" do |content|
      assert_includes content, '"sourceCodeDir": "app/frontend"'
    end

    assert_file "package.json" do |content|
      assert_includes content, '"dev": "vite"'
      assert_includes content, '"build": "vite build"'
      assert_includes content, '"vue": "^3.5.13"'
      assert_includes content, '"vite-plugin-ruby": "^5.1.1"'
    end

    assert_file "app/frontend/entrypoints/application.js" do |content|
      assert_includes content, "createApp"
    end

    assert_no_file "app/frontend/router.js"
  end

  def test_generator_spa_option_creates_router_shell_and_routes
    run_generator(["--spa"])

    assert_file "config/initializers/rails_vue_vite.rb" do |content|
      assert_includes content, "config.spa_mode = true"
    end

    assert_file "package.json" do |content|
      assert_includes content, '"vue-router": "^4.5.1"'
    end

    assert_file "app/frontend/entrypoints/application.js" do |content|
      assert_includes content, ".use(router)"
    end

    assert_file "app/frontend/router.js" do |content|
      assert_includes content, "createRouter"
    end

    assert_file "app/frontend/App.vue" do |content|
      assert_includes content, "<router-view />"
    end

    assert_file "app/controllers/spa_controller.rb" do |content|
      assert_includes content, "class SpaController < ActionController::Base"
      assert_includes content, "render :index"
    end
    assert_file "app/views/spa/index.html.erb" do |content|
      assert_includes content, "vite_javascript_tag"
    end

    assert_file "config/routes.rb" do |content|
      assert_includes content, 'root "spa#index"'
      assert_includes content, 'get "*path", to: "spa#index"'
    end
  end

  def test_generator_skips_existing_package_json
    File.write(File.join(destination_root, "package.json"), JSON.pretty_generate({
      "name" => "existing-app",
      "scripts" => { "test" => "vitest" },
      "dependencies" => { "axios" => "^1.8.0" }
    }))

    run_generator

    assert_file "package.json" do |content|
      assert_includes content, '"name": "existing-app"'
      assert_includes content, '"test": "vitest"'
      assert_includes content, '"axios": "^1.8.0"'
      refute_includes content, '"dev": "vite"'
      refute_includes content, '"vue": "^3.5.13"'
    end
  end

  private

  def create_routes_file
    FileUtils.mkdir_p(File.join(destination_root, "config"))
    File.write(File.join(destination_root, "config/routes.rb"), "Rails.application.routes.draw do\nend\n")
  end
end
