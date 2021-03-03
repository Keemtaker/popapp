Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show]

  get 'callback', to: "users#callback"
  get 'profile', to: "users#profile"


  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'callback', to: "pages#callback"
end
