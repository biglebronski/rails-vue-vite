# frozen_string_literal: true

require "json"
require "pathname"
require "active_support"
require "active_support/core_ext/module/attribute_accessors"
require "active_support/core_ext/object/blank"
require "rails"

require_relative "rails_vue_vite/version"
require_relative "rails_vue_vite/configuration"
require_relative "rails_vue_vite/manifest"
require_relative "rails_vue_vite/tag_builder"
require_relative "rails_vue_vite/helper"
require_relative "rails_vue_vite/engine"

module RailsVueVite
  class Error < StandardError; end
  class MissingEntrypointError < Error; end

  mattr_accessor :configuration, default: nil

  class << self
    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    def config
      self.configuration ||= Configuration.new
    end

    def reset!
      self.configuration = Configuration.new
    end
  end
end
