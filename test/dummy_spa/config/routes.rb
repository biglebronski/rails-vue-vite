Rails.application.routes.draw do
  namespace :api do
    resources :todos, only: [:index, :create, :destroy]
  end

  root "spa#index"
  get "/about", to: "spa#index"
  get "*path", to: "spa#index", constraints: ->(request) { !request.xhr? && request.format.html? }
end
