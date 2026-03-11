Rails.application.configure do
  config.enable_reloading = true
  config.eager_load = false
  config.consider_all_requests_local = true
  config.server_timing = true
  config.action_controller.perform_caching = false
  config.action_dispatch.verbose_redirect_logs = true
  config.action_controller.raise_on_missing_callback_actions = true
end
