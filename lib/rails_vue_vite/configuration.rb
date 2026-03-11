# frozen_string_literal: true

module RailsVueVite
  class Configuration
    attr_accessor :build_output_dir, :dev_server_url, :entrypoints_dir, :manifest_path,
      :mode, :public_output_dir, :source_code_dir, :spa_entrypoint, :spa_mode, :spa_mount_path

    def initialize
      @mode = ENV.fetch("RAILS_VUE_VITE_MODE", default_mode)
      @dev_server_url = ENV.fetch("RAILS_VUE_VITE_DEV_SERVER_URL", "http://localhost:5173")
      @source_code_dir = "app/frontend"
      @entrypoints_dir = "entrypoints"
      @public_output_dir = "vite"
      @build_output_dir = File.join("public", @public_output_dir)
      @manifest_path = File.join(@build_output_dir, ".vite", "manifest.json")
      @spa_mode = false
      @spa_entrypoint = "application"
      @spa_mount_path = "/"
    end

    def dev_mode?
      mode.to_s == "development"
    end

    def production_mode?
      !dev_mode?
    end

    def entrypoint_root
      File.join(source_code_dir, entrypoints_dir)
    end

    def spa_mode?
      !!spa_mode
    end

    private

    def default_mode
      ENV["RAILS_ENV"] == "development" ? "development" : "production"
    end
  end
end
