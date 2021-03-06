require 'rails_helper'

feature "Accounts", %q{

} do

  context "As a non-logged in user" do
    scenario "Trying to view some accounts" do
      visit accounts_path

      expect(current_path).to eq new_user_session_path

      expect(page).to have_content("You need to sign in or sign up before continuing.")
    end

    scenario "Trying to create a new account" do
      visit new_account_path

      expect(current_path).to eq new_user_session_path

      expect(page).to have_content("You need to sign in or sign up before continuing.")
    end

    scenario "Trying to edit an existing account" do
      account = FactoryGirl.create(:account)

      visit edit_account_path(account)

      expect(current_path).to eq new_user_session_path

      expect(page).to have_content("You need to sign in or sign up before continuing.")
    end
  end

  context "As a logged in user" do
    before do
      @user = FactoryGirl.create(:user)
      sign_in_as @user
    end

    scenario "Viewing an empty list of accounts" do
      visit accounts_path

      expect(page).to have_content("Accounts")

      expect(page).to have_content("You have no accounts. Try making one here.")
      expect(page).to have_link("here", href: new_account_path)
    end

    scenario "Viewing your accounts" do
      @user.accounts << FactoryGirl.create(:account, name: "Account #1")
      @user.accounts << FactoryGirl.create(:account, name: "Account #2")

      visit accounts_path

      expect(page).to have_content("Accounts")

      expect(page).to have_table_columns(["Name", "Actions"])

      expect(page).to have_table_rows_in_order(
        ["Account #1", "Edit Delete"],
        ["Account #2", "Edit Delete"]
      )
    end

    scenario "Creating a new account" do
      visit accounts_path

      expect(page).to have_link("New Account", href: new_account_path)

      click_link "New Account"

      expect(page).to have_content("New Account")

      expect(page).to have_field("Name")
      expect(page).to have_field("Starting balance")
      click_button "Create Account"

      expect(page).to have_content("Account not created.")
      within ".account_name" do
        expect(page).to have_content("can't be blank")
      end
      within ".account_starting_balance" do
        expect(page).to have_content("can't be blank")
      end

      fill_in "Name", with: "My First Account"
      fill_in "Starting balance", with: 250
      click_button "Create Account"

      expect(current_path).to eq accounts_path
      expect(page).to have_content("Account successfully created.")

      expect(page).to have_table_rows_in_order(
        ["My First Account", "Edit Delete"]
      )
    end

    context "editing an account" do
      scenario "as the user whose account it is" do
        FactoryGirl.create(:account, name: "Original Account", starting_balance: 250, user: @user)

        visit accounts_path

        expect(page).to have_table_rows_in_order(
          ["Original Account", "Edit Delete"]
        )

        expect(page).to have_link("Edit")
        click_link("Edit")

        expect(page).to have_content("Edit Account")
        expect(page).to have_field("Name", with: "Original Account")
        expect(page).to have_field("Starting balance", with: "250.00")
        fill_in "Name", with: ""
        click_button "Update Account"

        expect(page).to have_content("Account not updated.")
        within ".account_name" do
          expect(page).to have_content("can't be blank")
        end

        fill_in "Name", with: "Edited Account"
        click_button "Update Account"

        expect(current_path).to eq accounts_path
        expect(page).to have_content("Account successfully updated.")

        expect(page).to have_table_rows_in_order(
          ["Edited Account", "Edit Delete"]
        )
      end

      scenario "as a different user" do
        account = FactoryGirl.create(:account, name: "Not My Account")

        visit accounts_path

        expect(page).to_not have_content("Not My Account")

        visit edit_account_path(account)

        expect(current_path).to eq accounts_path

        expect(page).to have_content("Account could not be found.")
      end
    end

    scenario "deleting an account" do
      FactoryGirl.create(:account, name: "Old Account", user: @user)

      visit accounts_path

      expect(page).to have_link("Delete")

      click_link "Delete"

      expect(current_path).to eq accounts_path

      expect(page).to_not have_content("Old Account")

      expect(page).to have_content("Account successfully deleted.")
    end
  end
end
