# frozen_string_literal: true

module RailsVueVite
  class Engine < ::Rails::Engine
    initializer "rails_vue_vite.view_helpers" do
      ActiveSupport.on_load(:action_view) do
        include RailsVueVite::Helper
      end
    end
  end
end
