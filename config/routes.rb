Rails.application.routes.draw do
  get 'users/show'
  get 'users/new'
  root 'static_pages#home'
  get 'static_pages/help'

  get "/signup",  to: "users#new"
  resources :users
end
