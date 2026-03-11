# frozen_string_literal: true

require "test_helper"

class RailsVueViteConfigurationTest < Minitest::Test
  def setup
    RailsVueVite.reset!
  end

  def test_defaults_match_expected_rails_convention
    config = RailsVueVite.config

    assert_equal "app/frontend", config.source_code_dir
    assert_equal "entrypoints", config.entrypoints_dir
    assert_equal "vite", config.public_output_dir
    assert_equal "public/vite", config.build_output_dir
    assert_equal "public/vite/.vite/manifest.json", config.manifest_path
    assert_equal false, config.spa_mode
    assert_equal "application", config.spa_entrypoint
    assert_equal "/", config.spa_mount_path
  end

  def test_configure_mutates_shared_configuration
    RailsVueVite.configure do |config|
      config.mode = "development"
      config.dev_server_url = "http://127.0.0.1:3036"
      config.spa_mode = true
    end

    assert_equal "development", RailsVueVite.config.mode
    assert_equal "http://127.0.0.1:3036", RailsVueVite.config.dev_server_url
    assert RailsVueVite.config.dev_mode?
    assert RailsVueVite.config.spa_mode?
  end
end
