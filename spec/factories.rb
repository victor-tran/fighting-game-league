FactoryGirl.define do
  factory :user do
    first_name            "Victor"
    last_name             "Tran"
    self.alias            "BurlyChalice"
    email                 "dfaced@gmail.com"
    password              "foobar"
    password_confirmation "foobar"
  end

  factory :league do
    name                  "Example League"
    game_id               1
    commissioner_id       1
    started               false
    current_season_number 0
    current_round         0
    info                  "Example info"
    match_count           5
  end
end