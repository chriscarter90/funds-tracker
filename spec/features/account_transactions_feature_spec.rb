require 'rails_helper'

feature "Account Transactions", %q{

} do

  context "As a non-logged in user" do
    before do
      @account = FactoryGirl.create(:account)
    end

    scenario "Trying to view transactions for an account" do
      visit account_account_transactions_path(@account)

      expect(current_path).to eq new_user_session_path

      expect(page).to have_content("You need to sign in or sign up before continuing.")
    end
  end

  context "As a logged in user" do
    before do
      @user = FactoryGirl.create(:user)
      sign_in_as @user
    end

    context "with access" do
      before do
        @account = FactoryGirl.create(:account, name: "My Account", starting_balance: 123.45, user: @user)
      end

      scenario "Viewing transactions for an account" do
        FactoryGirl.create(:payment,
                           description: "Example Payment",
                           account_transaction: FactoryGirl.create(:account_transaction,
                                                                   account: @account,
                                                                   amount: 30.45,
                                                                   transaction_date: "01-05-2014")
                          )

        @transfer_account = FactoryGirl.create(:account, user: @user)
        FactoryGirl.create(:transfer,
                           other_account: @transfer_account,
                           account_transaction: FactoryGirl.create(:account_transaction,
                                                                   account: @account,
                                                                   amount: 12.34,
                                                                   transaction_date: "04-05-2014")
                          )

        visit accounts_path

        click_link "My Account"

        expect(current_path).to eq account_account_transactions_path(@account)

        expect(page).to have_content("My Account")
        expect(page).to have_content("Transactions")
        expect(page).to have_link("Back to accounts", href: accounts_path)

        expect(page).to have_table_columns(["Transaction date", "Description", "Tagged with...", "Amount", "Running total", "Actions"])

        expect(page).to have_table_rows_in_order(
          ["", "Ending balance", "", "", "£166.24", ""],
          ["4th May 2014", "Money transferred between ##{@account.id} and ##{@transfer_account.id}.", "TAGS GO HERE", "£12.34", "£166.24", "Edit Delete"],
          ["1st May 2014", "Example Payment", "TAGS GO HERE", "£30.45", "£153.90", "Edit Delete"],
          ["", "Starting balance", "", "", "£123.45", ""]
        )
      end

      scenario "Viewing a list of transactions with pagination" do
        1.upto(15) do |i|
          FactoryGirl.create(:payment,
                             description: "Transaction on day #{i}.",
                             account_transaction: FactoryGirl.create(:account_transaction,
                                                                     amount: 10,
                                                                     account: @account,
                                                                     transaction_date: "#{i}-05-2014")
                            )
        end

        visit account_account_transactions_path(@account)

        expect(page).to have_table_rows_in_order(
          ["", "Ending balance", "", "", "£273.45", ""],
          ["15th May 2014", "Transaction on day 15.", "TAGS GO HERE", "£10.00", "£273.45", "Edit Delete"],
          ["14th May 2014", "Transaction on day 14.", "TAGS GO HERE", "£10.00", "£263.45", "Edit Delete"],
          ["13th May 2014", "Transaction on day 13.", "TAGS GO HERE", "£10.00", "£253.45", "Edit Delete"],
          ["12th May 2014", "Transaction on day 12.", "TAGS GO HERE", "£10.00", "£243.45", "Edit Delete"],
          ["11th May 2014", "Transaction on day 11.", "TAGS GO HERE", "£10.00", "£233.45", "Edit Delete"],
          ["10th May 2014", "Transaction on day 10.", "TAGS GO HERE", "£10.00", "£223.45", "Edit Delete"],
          ["9th May 2014", "Transaction on day 9.", "TAGS GO HERE", "£10.00", "£213.45", "Edit Delete"],
          ["8th May 2014", "Transaction on day 8.", "TAGS GO HERE", "£10.00", "£203.45", "Edit Delete"],
          ["7th May 2014", "Transaction on day 7.", "TAGS GO HERE", "£10.00", "£193.45", "Edit Delete"],
          ["6th May 2014", "Transaction on day 6.", "TAGS GO HERE", "£10.00", "£183.45", "Edit Delete"],
          ["", "Starting balance", "", "", "£173.45", ""]
        )

        within '.pagination' do
          expect(page).to have_link("2", href: account_account_transactions_path(@account, page: 2))
          expect(page).to have_link("Next")
          expect(page).to have_link("Last")
        end

        click_link "Next"

        expect(page).to have_table_rows_in_order(
          ["", "Ending balance", "", "", "£173.45", ""],
          ["5th May 2014", "Transaction on day 5.", "TAGS GO HERE", "£10.00", "£173.45", "Edit Delete"],
          ["4th May 2014", "Transaction on day 4.", "TAGS GO HERE", "£10.00", "£163.45", "Edit Delete"],
          ["3rd May 2014", "Transaction on day 3.", "TAGS GO HERE", "£10.00", "£153.45", "Edit Delete"],
          ["2nd May 2014", "Transaction on day 2.", "TAGS GO HERE", "£10.00", "£143.45", "Edit Delete"],
          ["1st May 2014", "Transaction on day 1.", "TAGS GO HERE", "£10.00", "£133.45", "Edit Delete"],
          ["", "Starting balance", "", "", "£123.45", ""]
        )

        within '.pagination' do
          expect(page).to have_link("First")
          expect(page).to have_link("Prev")
          expect(page).to have_link("1", href: account_account_transactions_path(@account))
        end
      end

      scenario "Viewing an empty list of transactions" do
        visit account_account_transactions_path(@account)

        expect(page).to have_content("My Account")
        expect(page).to have_content("Transactions")

        expect(page).to have_content("You have no transactions. Try adding a payment or a transfer here.")
        expect(page).to have_link("payment", href: new_account_payment_path(@account))
        expect(page).to have_link("transfer", href: new_account_transfer_path(@account))
      end
    end

    context "without access" do
      before do
        @account = FactoryGirl.create(:account)
      end

      scenario "Trying to view transactions" do
        visit account_account_transactions_path(@account)

        expect(current_path).to eq accounts_path

        expect(page).to have_content("Account could not be found.")
      end
    end
  end
end
