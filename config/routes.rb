# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  use_doorkeeper do
    skip_controllers :applications, :authorized_applications, :authorizations
    controllers tokens: "oauth/tokens"
  end
  # devise_for :users

  resources :articles, only: [:index] do
    collection do
      post :webhook
    end
    member do
      post :bookmark
      post :remove_bookmark
    end
  end
  resources :bookmarks, only: [:index]
  resources :sources, only: [:index, :show], param: :slug do
    resources :articles, only: [:index], to: "sources#articles"
    collection do
      get :following
      get :suggested
    end
    member do
      post :follow
      post :unfollow
    end
  end
  resources :users, only: [:show] do
    collection do
      get :me
    end
  end
end
# rubocop:enable Metrics/BlockLength
