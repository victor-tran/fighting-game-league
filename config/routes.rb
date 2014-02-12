FightingGameLeague::Application.routes.draw do
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :leagues do
    member do
      patch :start, :next_round, :end_season
    end
  end
  resources :memberships, only: [:create, :destroy]
  resources :matches do
    member do
      get :edit_score
      patch :set_score, :confirm_score
    end
  end
  root :to => "home#index"

  match '/register', to: 'users#new', via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
end
