require 'spec_helper'

feature "Home page", %q{
  So that I can access the rest of the site,
  As a user,
  I wanna see a home page
} do

  scenario "As a non-logged in user" do
    visit root_path

    page.should have_content("Sign up")
    page.should have_content("Log in")

    page.should_not have_content("Log out")
    page.should_not have_content("Logged in as")
  end

  scenario "As a logged in user" do
    visit root_path

    user = FactoryGirl.create(:user, email: "bob@ineedalife.com")
    sign_in_as user

    page.should_not have_content("Sign up")
    page.should_not have_content("Log in")

    page.should have_content("Log out")
    page.should have_content("Logged in as bob@ineedalife.com")
  end
end
