Rails.application.routes.draw do
  post "articles/webhook", to: "articles#webhook"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
