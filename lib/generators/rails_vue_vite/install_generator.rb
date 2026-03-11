# frozen_string_literal: true

require "json"
require "rails/generators"

module RailsVueVite
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)
      class_option :spa, type: :boolean, default: false, desc: "Generate Vue Router SPA scaffolding and a Rails shell route"

      def create_initializer
        template "rails_vue_vite.rb.tt", "config/initializers/rails_vue_vite.rb"
      end

      def create_vite_config
        template "vite.config.ts.tt", "vite.config.ts"
      end

      def create_vite_json
        template "vite.json.tt", "config/vite.json"
      end

      def ensure_package_json
        package_json_path = File.join(destination_root, "package.json")

        if File.exist?(package_json_path)
          say_status :skip, "package.json already exists; refer to README.md for frontend dependency and script configuration", :yellow
          return
        end

        package_json = {}

        package_json["private"] = true if package_json["private"].nil?
        package_json["type"] = "module"
        package_json["scripts"] = (package_json["scripts"] || {}).merge(
          "dev" => "vite",
          "build" => "vite build"
        )

        package_json["dependencies"] = (package_json["dependencies"] || {}).merge(base_dependencies)
        package_json["devDependencies"] = (package_json["devDependencies"] || {}).merge(dev_dependencies)

        create_file "package.json", "#{JSON.pretty_generate(package_json)}\n"
      end

      def create_entrypoint
        template "application.js.tt", "app/frontend/entrypoints/application.js"
      end

      def create_spa_files
        return unless options["spa"]

        template "router.js.tt", "app/frontend/router.js"
        template "App.vue.tt", "app/frontend/App.vue"
        template "spa_controller.rb.tt", "app/controllers/spa_controller.rb"
        template "spa_index.html.erb.tt", "app/views/spa/index.html.erb"
      end

      def create_spa_route
        return unless options["spa"]

        route <<~RUBY
          root "spa#index"
          get "*path", to: "spa#index", constraints: ->(request) { !request.xhr? && request.format.html? }
        RUBY
      end

      private

      def base_dependencies
        dependencies = {
          "vue" => "^3.5.13"
        }

        dependencies["vue-router"] = "^4.5.1" if options["spa"]
        dependencies
      end

      def dev_dependencies
        {
          "@vitejs/plugin-vue" => "^5.2.1",
          "vite" => "^6.2.2",
          "vite-plugin-ruby" => "^5.1.1"
        }
      end
    end
  end
end
