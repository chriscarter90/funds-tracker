module SignInHelpers
  def sign_in_as(user)
    visit new_user_session_path
    fill_in_sign_in_fields(user)
  end

  def fill_in_sign_in_fields(user)
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
  end
end

RSpec.configure do |config|
  config.include SignInHelpers
end
