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
      get :p1_edit_score, :p2_edit_score, :p1_edit_character, :p2_edit_character
      patch :p1_set_score, :p2_set_score, :confirm_score, :p1_set_character, :p2_set_character
    end
  end
  resources :bets, only: [:create]
  root :to => "home#index"

  match '/register', to: 'users#new', via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
end
