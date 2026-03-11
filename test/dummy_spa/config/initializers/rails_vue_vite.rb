# frozen_string_literal: true

RailsVueVite.configure do |config|
  config.mode = "development"
  config.dev_server_url = "http://localhost:5173"
  config.spa_mode = true
  config.spa_entrypoint = "application"
  config.spa_mount_path = "/"
end
