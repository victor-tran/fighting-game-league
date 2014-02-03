FightingGameLeague::Application.routes.draw do
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :leagues
  resources :memberships, only: [:create, :destroy]
  resources :matches, only: [:edit]
  root :to => "home#index"

  match '/register', to: 'users#new', via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
end
