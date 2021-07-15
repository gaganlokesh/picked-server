Rails.application.routes.draw do
  use_doorkeeper do
    skip_controllers :applications, :authorized_applications, :authorizations
  end
  devise_for :users

  resources :articles, only: [:index]
  post "articles/webhook", to: "articles#webhook"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
