# frozen_string_literal: true

require "test_helper"

class RailsVueViteHelperTest < Minitest::Test
  class TestView < ActionView::Base
    include RailsVueVite::Helper
  end

  def setup
    RailsVueVite.reset!
  end

  def test_dev_mode_emits_vite_client_and_entrypoint_tags
    RailsVueVite.configure do |config|
      config.mode = "development"
      config.dev_server_url = "http://localhost:5173"
    end

    view = TestView.empty

    assert_includes view.vite_client_tag, "http://localhost:5173/vite/@vite/client"
    assert_includes view.vite_javascript_tag("application"), "http://localhost:5173/vite/entrypoints/application.js"
  end

  def test_production_mode_reads_manifest_and_emits_asset_tags
    with_tmpdir do |root|
      write_manifest(root, {
        "entrypoints/application.js" => {
          "file" => "assets/application-abc.js",
          "css" => ["assets/application-abc.css", "assets/theme-def.css"]
        }
      })

      RailsVueVite.configure { |config| config.mode = "production" }
      view = TestView.empty
      manifest = RailsVueVite::Manifest.new(root: root)
      builder = RailsVueVite::TagBuilder.new(view, manifest: manifest)

      javascript = builder.javascript_tags("application")
      stylesheets = builder.stylesheet_tags("application")

      assert_includes javascript, "/vite/assets/application-abc.js"
      assert_includes stylesheets, "/vite/assets/application-abc.css"
      assert_includes stylesheets, "/vite/assets/theme-def.css"
    end
  end

  def test_production_stylesheets_are_deduplicated
    with_tmpdir do |root|
      write_manifest(root, {
        "entrypoints/application.js" => {
          "file" => "assets/application-abc.js",
          "css" => ["assets/shared.css"]
        },
        "entrypoints/admin.js" => {
          "file" => "assets/admin-abc.js",
          "css" => ["assets/shared.css"]
        }
      })

      RailsVueVite.configure { |config| config.mode = "production" }
      view = TestView.empty
      manifest = RailsVueVite::Manifest.new(root: root)
      builder = RailsVueVite::TagBuilder.new(view, manifest: manifest)

      html = builder.stylesheet_tags("application", "admin")

      assert_equal 1, html.scan("shared.css").length
    end
  end

  private

  def write_manifest(root, payload)
    manifest_dir = File.join(root, "public/vite/.vite")
    FileUtils.mkdir_p(manifest_dir)
    File.write(File.join(manifest_dir, "manifest.json"), JSON.pretty_generate(payload))
  end
end
