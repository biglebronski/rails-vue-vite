# frozen_string_literal: true

module RailsVueVite
  module Helper
    def vite_client_tag(**options)
      vite_tag_builder.client_tag(**options)
    end

    def vite_javascript_tag(*entrypoints, **options)
      vite_tag_builder.javascript_tags(*entrypoints, **options)
    end

    def vite_stylesheet_tag(*entrypoints, **options)
      vite_tag_builder.stylesheet_tags(*entrypoints, **options)
    end

    private

    def vite_tag_builder
      @vite_tag_builder ||= TagBuilder.new(self)
    end
  end
end
