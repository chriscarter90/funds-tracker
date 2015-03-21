user = User.where(email: "user@example.com").first

if user
  ["Account #1", "Account #2", "Account #3"].each do |account_name|
    user.accounts.where(name: account_name).first_or_create do |a|
      a.starting_balance = 100
    end
  end
end
