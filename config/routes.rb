Rails.application.routes.draw do
  get 'sessions/new'
  get 'users/show'
  get 'users/new'
  root 'static_pages#home'
  get 'static_pages/help'

  get "/signup",  to: "users#new"
  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :relationships,
    only: [:create, :destroy]

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :microposts, only: [:create, :destroy]

end
