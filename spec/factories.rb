FactoryGirl.define do
  sequence(:email) { |n| "test-user#{n}@example.com" }

  factory :user do
    first_name            { Faker::Name.first_name }
    last_name             { Faker::Name.last_name }
    email
    password              "password"
    password_confirmation "password"
  end

  factory :account do
    name { Faker::Lorem.words(3).join(" ") }
    starting_balance { 1 + (rand(899)/100) }
    user
  end

  factory :transaction do
    description { Faker::Lorem.words(7).join(" ") }
    # Generates an amount anywhere between £1 and £9.99
    amount { 1 + (rand(899)/100) }
    account
    transaction_date { 2.weeks.ago }
  end
end
