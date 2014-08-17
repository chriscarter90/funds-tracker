require 'spec_helper'

feature "Home page", %q{
  So that I can access the rest of the site,
  As a user,
  I wanna see a home page
} do

  scenario "As a non-logged in user" do
    visit root_path

    expect(page).to have_link("Sign up", href: new_user_registration_path)
    expect(page).to have_link("Log in", href: new_user_session_path)

    within '.jumbotron' do
      expect(page).to have_content("FundsTracker")
      expect(page).to have_content("So I heard you wanted to keep track of your funds?")

      expect(page).to have_content("Want in?")
      expect(page).to have_link("Why not sign up?", href: new_user_registration_path)

      expect(page).to have_content("Already in?")
      expect(page).to have_link("Log me in!", href: new_user_session_path)

      expect(page).to_not have_link("Take me to my accounts!")
    end

    expect(page).to_not have_link("Log out")
    expect(page).to_not have_content("Logged in as")

    expect(page).to_not have_link("Sections")
    expect(page).to_not have_link("Accounts")
    expect(page).to_not have_link("Tags")
  end

  scenario "As a logged in user" do
    visit root_path

    user = FactoryGirl.create(:user, email: "bob@ineedalife.com")
    sign_in_as user

    expect(current_path).to eq root_path

    expect(page).to_not have_link("Sign up")
    expect(page).to_not have_link("Log in")

    within '.jumbotron' do
      expect(page).to have_content("FundsTracker")
      expect(page).to have_content("So I heard you wanted to keep track of your funds?")

      expect(page).to_not have_content("Want in?")
      expect(page).to_not have_link("Why not sign up?", href: new_user_registration_path)

      expect(page).to_not have_content("Already in?")
      expect(page).to_not have_link("Log me in!", href: new_user_session_path)

      expect(page).to have_link("Take me to my accounts!", href: accounts_path)
    end

    expect(page).to have_link("Log out", href: destroy_user_session_path)
    expect(page).to have_content("Logged in as bob@ineedalife.com")

    expect(page).to have_link("Sections", href: '#')
    expect(page).to have_link("Accounts", href: accounts_path)
    expect(page).to have_link("Tags", href: tags_path)
    expect(page).to have_link("Transfers", href: transfers_path)
  end
end
