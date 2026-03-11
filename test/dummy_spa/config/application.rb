require_relative "boot"

require "rails"
require "action_controller/railtie"
require "action_view/railtie"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module DummySpa
  class Application < Rails::Application
    config.load_defaults 7.2
    config.eager_load = false
    config.generators.system_tests = nil
  end
end
