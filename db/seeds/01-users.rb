User.where(email: "user@example.com").first_or_create do |user|
  user.first_name = Faker::Name.first_name
  user.last_name  = Faker::Name.last_name
  user.password   = user.password_confirmation = "letmein!"
end
