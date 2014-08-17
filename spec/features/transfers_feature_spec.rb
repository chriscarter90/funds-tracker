require 'spec_helper'

feature "Transfers", %q{

} do

  context "As a non-logged in user" do
    scenario "Trying to view some transfers" do
      visit transfers_path

      expect(current_path).to eq new_user_session_path
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
  end
end
