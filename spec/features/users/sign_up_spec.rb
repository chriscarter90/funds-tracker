require 'spec_helper'

feature "Signing up", %q{

} do

  scenario "Signing up to the site" do
    visit root_path

    expect(page).to have_link("Why not sign up?", href: new_user_registration_path)

    click_link "Why not sign up?"

    expect(current_path).to eq new_user_registration_path

    expect(page).to have_field("First name")
    expect(page).to have_field("Last name")
    expect(page).to have_field("Email")
    expect(page).to have_field("Password")
    expect(page).to have_field("Password confirmation")

    fill_in "Email", with: "new_user@example.com"
    fill_in "Password", with: "password", match: :prefer_exact
    fill_in "Password confirmation", with: "password"

    click_button "Sign up"

    within ".user_first_name" do
      expect(page).to have_content("can't be blank")
    end

    within ".user_last_name" do
      expect(page).to have_content("can't be blank")
    end

    fill_in "First name", with: "Bob"
    fill_in "Last name", with: "User"
    fill_in "Password", with: "password", match: :prefer_exact
    fill_in "Password confirmation", with: "password"

    click_button "Sign up"

    expect(current_path).to eq accounts_path

    expect(page).to have_content("You have no accounts.")
    expect(page).to have_content("Try making one here.")
    expect(page).to have_link("here", href: new_account_path)
  end
end
