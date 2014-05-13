unless Rails.env.production?
  User.where(email: "user@example.com").first_or_create do |user|
    user.password = user.password_confirmation = "letmein!"
  end
end
