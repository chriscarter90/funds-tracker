require 'spec_helper'

feature "Editing details", %q{

} do

  context "Editing a users details" do
    before do
      user = FactoryGirl.create(:user, first_name: "Bob", last_name: "User", email: "bob.user@example.com", password: "password", password_confirmation: "password")

      sign_in_as user

      expect(page).to have_content("Logged in as bob.user@example.com")
      expect(page).to have_link("Edit my details")

      click_link "Edit my details"

      expect(current_path).to eq edit_user_registration_path

      expect(page).to have_field("First name", with: "Bob")
      expect(page).to have_field("Last name", with: "User")
      expect(page).to have_field("Email", with: "bob.user@example.com")
      expect(page).to have_field("Password")
      expect(page).to have_field("Password confirmation")
    end

    scenario "without requiring a password" do
      fill_in "First name", with: "Edited"
      fill_in "Last name", with: "Details"

      click_button "Update"

      expect(page).to have_content("Details successfully updated.")
      expect(current_path).to eq accounts_path
    end

    scenario "requiring a password" do
      fill_in "Email", with: "new.email@example.com"

      click_button "Update"

      within '.user_current_password' do
        expect(page).to have_content("can't be blank")
      end

      fill_in "Current password", with: "password"

      click_button "Update"

      expect(page).to have_content("Details successfully updated.")
      expect(current_path).to eq accounts_path

      expect(page).to have_content("Logged in as new.email@example.com")
    end
  end
end
