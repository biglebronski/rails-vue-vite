Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    resources :widget_todos, only: [:index, :create, :destroy]
  end

  root "pages#home"
  get "/about", to: "pages#about"
end
