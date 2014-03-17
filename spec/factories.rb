FactoryGirl.define do
  factory :user do
    first_name            "Victor"
    last_name             "Tran"
    self.alias            "BurlyChalice"
    email                 "dfaced@gmail.com"
    password              "foobar"
    password_confirmation "foobar"
  end
end