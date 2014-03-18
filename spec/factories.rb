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
end