FactoryGirl.define do
  factory :game do
    name "USF4"
    logo "lol.png"
  end

  factory :user do
    first_name            "Example"
    last_name             "User"
    sequence(:alias)       { |n| "Person #{n}" }
    sequence(:email)       { |n| "person_#{n}@example.com"}
    password               "foobar"
    password_confirmation  "foobar"
    fight_bucks            50
  end

  factory :league do
    sequence(:name)       { |n| "Example League #{n}" }
    game
    match_count           5
    info                  "Example text"
    commissioner_id       1
    started               false
    current_season_number 0
    current_round         0
  end

  factory :match do
    round_number  1 
    p1_id         1
    p2_id         2
    season_number 1
    league_id     league
    p1_accepted   false
    p2_accepted   false
    game_id       1
  end
end