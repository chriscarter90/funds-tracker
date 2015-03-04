require 'rails_helper'

feature "Transfers", %q{

} do

  context "As a non-logged in user" do
    scenario "Trying to view some transfers" do
      visit transfers_path

      expect(current_path).to eq new_user_session_path
    end

    scenario "Trying to create a new transfer" do
      visit new_transfer_path

      expect(current_path).to eq new_user_session_path

      expect(page).to have_content("You need to sign in or sign up before continuing.")
    end

    scenario "Trying to edit an existing transfer" do
      transfer = FactoryGirl.create(:transfer)

      visit edit_transfer_path(transfer)

      expect(current_path).to eq new_user_session_path

      expect(page).to have_content("You need to sign in or sign up before continuing.")
    end
  end

  context "As a logged in user" do
    before do
      @user = FactoryGirl.create(:user)
      sign_in_as @user
    end

    scenario "Viewing an empty list of transfers" do
      visit transfers_path

      expect(page).to have_content("Transfers")

      expect(page).to have_content("You have no transfers. Try adding one here")
      expect(page).to have_link("here", href: new_transfer_path)
    end

    scenario "Viewing transfers" do
      @account1 = FactoryGirl.create(:account, user: @user, name: "Account #1")
      @account2 = FactoryGirl.create(:account, user: @user, name: "Account #2")

      FactoryGirl.create(:transfer, to_account: @account2, from_account: @account1, amount: 100, transfer_date: "01-08-2014")
      FactoryGirl.create(:transfer, to_account: @account1, from_account: @account2, amount: 200, transfer_date: "31-07-2014")

      visit transfers_path

      expect(page).to have_content("Transfers")

      expect(page).to have_table_columns(["Transfer date", "From", "To", "Amount"])

      expect(page).to have_table_rows_in_order(
        ["1st August 2014", "Account #1", "Account #2", "£100.00"],
        ["31st July 2014", "Account #2", "Account #1", "£200.00"]
      )
    end

    scenario "Creating a new transfer" do
      @account1 = FactoryGirl.create(:account, user: @user, name: "Account #1")
      @account2 = FactoryGirl.create(:account, user: @user, name: "Account #2")

      @other_account = FactoryGirl.create(:account, name: "Not My Account")

      Timecop.freeze(2014, 1, 1) do
        visit transfers_path

        expect(page).to have_link("New Transfer", href: new_transfer_path)

        click_link "New Transfer"

        expect(page).to have_content("New Transfer")

        expect(page).to have_field("Amount")
        expect(page).to have_field("Transfer date", with: "01-01-2014")
        expect(page).to have_select("From account", options: ["-- Select an account --", "Account #1", "Account #2"])
        expect(page).to have_select("To account", options: ["-- Select an account --", "Account #1", "Account #2"])
        click_button "Create Transfer"

        expect(page).to have_content("Transfer not created.")
        within ".transfer_amount" do
          expect(page).to have_content("can't be blank")
        end
        within ".transfer_from_account" do
          expect(page).to have_content("can't be blank")
        end
        within ".transfer_to_account" do
          expect(page).to have_content("can't be blank")
        end

        fill_in "Amount", with: 21.04
        select "Account #1", from: "From account"
        select "Account #2", from: "To account"

        click_button "Create Transfer"

        expect(current_path).to eq transfers_path
        expect(page).to have_content("Transfer successfully created.")
        expect(page).to have_table_rows_in_order(
          ["1st January 2014", "Account #1", "Account #2", "£21.04"],
        )
      end
    end

    context "editing a transfer" do
      scenario "as the user whose transfer it is" do
        FactoryGirl.create(:transfer, transfer_date: "01-03-2015", amount: 200,
                           to_account:   FactoryGirl.create(:account, user: @user, name: "Account #2"),
                           from_account: FactoryGirl.create(:account, user: @user, name: "Account #1"))

        visit transfers_path

        expect(page).to have_table_rows_in_order(
          ["1st March 2015", "Account #1", "Account #2", "£200.00"],
        )

        expect(page).to have_link("Edit")
        click_link("Edit")

        expect(page).to have_content("Edit Transfer")
        expect(page).to have_field("Amount", with: "200.00")
        expect(page).to have_field("Transfer date", with: "01-03-2015")
        expect(page).to have_select("From account", options: ["-- Select an account --", "Account #1", "Account #2"], selected: "Account #1")
        expect(page).to have_select("To account", options: ["-- Select an account --", "Account #1", "Account #2"], selected: "Account #2")

        fill_in "Amount", with: nil
        click_button "Update Transfer"

        expect(page).to have_content("Transfer not updated.")

        within ".transfer_amount" do
          expect(page).to have_content("can't be blank")
        end

        fill_in "Amount", with: 500
        click_button "Update Transfer"

        expect(current_path).to eq transfers_path
        expect(page).to have_content("Transfer successfully updated.")

        expect(page).to have_table_rows_in_order(
          ["1st March 2015", "Account #1", "Account #2", "£500.00"],
        )
      end

      scenario "as a different user" do
        transfer = FactoryGirl.create(:transfer, transfer_date: "25-12-2014")

        visit transfers_path

        expect(page).to_not have_content("25th December 2014")

        visit edit_transfer_path(transfer)

        expect(current_path).to eq transfers_path

        expect(page).to have_content("Transfer could not be found.")
      end
    end
  end
end
