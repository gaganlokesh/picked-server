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
      post :bookmark, to: "bookmarks#create"
      delete :bookmark, to: "bookmarks#destroy"
      post :upvote, to: "reactions#create", defaults: { reactable_type: "Article" }
      delete :upvote, to: "reactions#destroy", defaults: { reactable_type: "Article" }
      post :view, to: "views#create"
      post :report, to: "reports#create", defaults: { reportable_type: "Article" }
      post :hide
    end
  end
  resources :bookmarks, only: [:index]
  resource :feed, only: [:show] do
    get ":type", to: "feeds#show", as: :type
  end
  resources :sources, only: %i[index show], param: :slug do
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
      get :validate_username
      post :dismiss_action
    end
  end

  get "oauth/authorize", to: "oauth/authorize#index"
end
# rubocop:enable Metrics/BlockLength
