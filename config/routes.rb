FightingGameLeague::Application.routes.draw do
  resources :users do
    member do
      get :following, :followers, :fight_history
    end
    resources :posts, only: [:show]
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :leagues do
    resources :seasons, only: [:show]
    member do
      get :statistics, :join_password, :profile, :standings, :fighters,
          :followers, :edit_fighter_list
      patch :start, :next_round, :end_season, :start_playoffs,
            :end_playoffs, :set_fighter_list
    end
    resources :posts, only: [:show]
  end
  resources :memberships, only: [:create, :destroy]
  resources :matches do
    member do
      get :p1_edit_score, :p2_edit_score, :p1_edit_character, :p2_edit_character,
          :edit_dispute, :edit_date, :p1_betters, :p2_betters
      patch :p1_set_score, :p2_set_score, :accept_score, :decline_score,
            :p1_set_character, :p2_set_character, :dispute, :resolve, :set_date,
            :add_video
      delete :delete_video
    end
  end
  resources :bets, only: [:create]
  resources :tournaments do
    member do
      get :edit_match_scores
      patch :set_match_scores
    end
  end
  resources :orders do
    get :execute, :cancel

    collection do
      get :credit_card
      patch :pay_with_credit_card
    end
  end
  resources :relationships, only: [:create, :destroy]
  resources :league_relationships, only: [:create, :destroy]
  resources :likes, only: [:create, :destroy]
  resources :comments, only: [:create, :destroy]

  root to: "home#index"

  get "home/stats"
  get "home/about"
  get "home/contact"
  get "home/fight_bucks"
  get "home/matchups"

  match '/register', to: 'users#new', via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
  match "/stats", to: 'home#stats', via: 'get'
  match "/contact", to: 'home#contact', via: 'get'
  match "/about", to: 'home#about', via: 'get'
  match "/fight_bucks", to: 'home#fight_bucks', via: 'get'
  match "/matchups", to: 'home#matchups', via: 'get'
  match '/users/:uuid/confirmation' => 'users#confirmation', via: 'get',
                                        as: 'confirmation'
  post 'pusher/auth'
  match '/read', to: 'home#read_notifications', as: 'read_notifications',
                 via: 'post'
  match "/search", to: 'home#search', via: 'get'
end
