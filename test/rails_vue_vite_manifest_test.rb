# frozen_string_literal: true

require "test_helper"

class RailsVueViteManifestTest < Minitest::Test
  def setup
    RailsVueVite.reset!
  end

  def test_resolves_entrypoint_using_default_key_format
    with_tmpdir do |root|
      write_manifest(root, {
        "entrypoints/application.js" => {
          "file" => "assets/application-123.js",
          "css" => ["assets/application-123.css"]
        }
      })

      manifest = RailsVueVite::Manifest.new(root: root)

      assert_equal "assets/application-123.js", manifest.asset_path_for("application")
      assert_equal ["assets/application-123.css"], manifest.stylesheet_paths_for("application")
    end
  end

  def test_raises_for_missing_entrypoint
    with_tmpdir do |root|
      write_manifest(root, {})

      manifest = RailsVueVite::Manifest.new(root: root)

      error = assert_raises(RailsVueVite::MissingEntrypointError) { manifest.asset_path_for("application") }
      assert_includes error.message, "application"
    end
  end

  def test_raises_for_invalid_manifest_json
    with_tmpdir do |root|
      manifest_dir = File.join(root, "public/vite/.vite")
      FileUtils.mkdir_p(manifest_dir)
      File.write(File.join(manifest_dir, "manifest.json"), "{invalid")

      manifest = RailsVueVite::Manifest.new(root: root)

      assert_raises(RailsVueVite::Error) { manifest.asset_path_for("application") }
    end
  end

  def test_supports_legacy_full_entrypoint_keys
    with_tmpdir do |root|
      write_manifest(root, {
        "app/frontend/entrypoints/application.js" => {
          "file" => "assets/application-legacy.js"
        }
      })

      manifest = RailsVueVite::Manifest.new(root: root)

      assert_equal "assets/application-legacy.js", manifest.asset_path_for("application")
    end
  end

  private

  def write_manifest(root, payload)
    manifest_dir = File.join(root, "public/vite/.vite")
    FileUtils.mkdir_p(manifest_dir)
    File.write(File.join(manifest_dir, "manifest.json"), JSON.pretty_generate(payload))
  end
end
