FightingGameLeague::Application.routes.draw do
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :leagues do
    member do
      get :statistics, :join_password, :profile, :standings, :fighters
      patch :start, :next_round, :end_season
    end
  end
  resources :memberships, only: [:create, :destroy]
  resources :matches do
    member do
      get :p1_edit_score, :p2_edit_score, :p1_edit_character, :p2_edit_character,
          :edit_dispute, :edit_date
      patch :p1_set_score, :p2_set_score, :confirm_score, :p1_set_character, 
            :p2_set_character, :dispute, :resolve, :set_date
    end
  end
  resources :bets, only: [:create]
  root :to => "home#index"

  get "home/stats"
  get "home/about"

  match '/register', to: 'users#new', via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
  match "/stats", to: 'home#stats', via: 'get'
  match "/about", to: 'home#about', via: 'get'
end
