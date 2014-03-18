FactoryGirl.define do
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
    name                  "Example League"
    game_id               1
    match_count           5
    info                  "Example text"
    commissioner_id       1
    started               false
    current_season_number 0
    current_round         0
  end
end