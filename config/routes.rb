FightingGameLeague::Application.routes.draw do
  get "payment_notifications/create"
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :leagues do
    member do
      get :statistics, :join_password, :profile, :standings, :fighters
      patch :start, :next_round, :end_season, :start_playoffs,
            :end_playoffs
    end
  end
  resources :memberships, only: [:create, :destroy]
  resources :matches do
    member do
      get :p1_edit_score, :p2_edit_score, :p1_edit_character, :p2_edit_character,
          :edit_dispute, :edit_date
      patch :p1_set_score, :p2_set_score, :accept_score, :decline_score,
            :p1_set_character, :p2_set_character, :dispute, :resolve, :set_date
    end
  end
  resources :bets, only: [:create]
  resources :tournaments do
    member do
      get :edit_match_scores
      patch :set_match_scores
    end
  end
  resources :home do
    collection do
      patch :pay_via_paypal
    end
  end
  resources :orders do
    get :execute
    get :cancel
  end
  root :to => "home#index"

  get "home/stats"
  get "home/about"
  get "home/fight_bucks"
  get "users/pending"

  match '/register', to: 'users#new', via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
  match "/stats", to: 'home#stats', via: 'get'
  match "/about", to: 'home#about', via: 'get'
  match "/fight_bucks", to: 'home#fight_bucks', via: 'get'
  match '/users/:uuid/confirmation' => 'users#confirmation', :via => :get,
                                        as: 'confirmation'
  #match "/" => redirect("/"), :via => :post
end
