FactoryGirl.define do
  sequence(:email) { |n| "test-user#{n}@example.com" }

  factory :user do
    email
    password              "password"
    password_confirmation "password"
  end

  factory :account do
    name { Faker::Lorem.words(3).join(" ") }
    user
  end
end
