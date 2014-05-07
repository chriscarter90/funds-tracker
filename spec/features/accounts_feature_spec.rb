require 'spec_helper'

feature "Accounts", %q{

} do

  context "As a non-logged in user" do
    scenario "Trying to create a new account" do
      visit new_account_path

      expect(current_path).to eq new_user_session_path

      expect(page).to have_content("You need to sign in or sign up before continuing.")
    end
  end

  context "As a logged in user" do
    before do
      user = FactoryGirl.create(:user)
      sign_in_as user
    end

    scenario "Viewing an empty list of accounts" do
      visit accounts_path

      expect(page).to have_content("You have no accounts. Try making one here.")
      expect(page).to have_link("here", href: new_account_path)
    end

    scenario "Creating a new account" do
      visit new_account_path

      expect(page).to have_content("New Account")

      expect(page).to have_field("Name")
      click_button "Create Account"

      within ".account_name" do
        expect(page).to have_content("can't be blank")
      end

      fill_in "Name", with: "My First Account"
      click_button "Create Account"

      expect(current_path).to eq accounts_path
      expect(page).to have_content("My First Account")
    end
  end
end
