Rails.application.routes.draw do
  use_doorkeeper do
    skip_controllers :applications, :authorized_applications, :authorizations
    controllers tokens: "oauth/tokens"
  end
  # devise_for :users

  resources :articles, only: [:index]
  post "articles/webhook", to: "articles#webhook"
  resources :sources, only: [:index, :show], param: :slug do
    resources :articles, only: [:index], to: "sources#articles"
  end
  resources :users, only: [:show] do
    collection do
      get :me
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
