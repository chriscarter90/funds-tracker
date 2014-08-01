require 'spec_helper'

feature "Transactions", %q{

} do

  context "As a non-logged in user" do
    before do
      @account = FactoryGirl.create(:account)
    end

    scenario "Trying to view transactions for an account" do
      visit account_transactions_path(@account)

      expect(current_path).to eq new_user_session_path

      expect(page).to have_content("You need to sign in or sign up before continuing.")
    end

    scenario "Trying to add a transaction to an account" do
      visit new_account_transaction_path(@account)

      expect(current_path).to eq new_user_session_path

      expect(page).to have_content("You need to sign in or sign up before continuing.")
    end

    scenario "Trying to edit an existing transaction" do
      transaction = FactoryGirl.create(:transaction, account: @account)

      visit edit_account_transaction_path(@account, transaction)

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
        @account.transactions << FactoryGirl.create(:transaction, description: "Example Transaction", amount: 30.48, transaction_date: "01-05-2014")
        @account.transactions << FactoryGirl.create(:transaction, description: "Another Transaction", amount: 12.34, transaction_date: "04-05-2014")

        visit accounts_path

        click_link "My Account"

        expect(current_path).to eq account_transactions_path(@account)

        expect(page).to have_content("My Account")
        expect(page).to have_content("Transactions")
        expect(page).to have_link("Back to accounts", href: accounts_path)

        expect(page).to have_table_columns(["Transaction date", "Description", "Tagged with...", "Amount", "Running total", "Actions"])

        expect(page).to have_table_rows_in_order(
          ["", "Ending balance", "", "", "£166.27", ""],
          ["4th May 2014", "Another Transaction", "", "£12.34", "£166.27", "Edit Delete"],
          ["1st May 2014", "Example Transaction", "", "£30.48", "£153.93", "Edit Delete"],
          ["", "Starting balance", "", "", "£123.45", ""]
        )
      end

      scenario "Viewing a list of transactions with pagination" do
        1.upto(15) do |i|
          @account.transactions << FactoryGirl.create(:transaction, description: "Transaction on day #{i}.", transaction_date: "#{i}-05-2014", amount: 10)
        end

        visit account_transactions_path(@account)

        expect(page).to have_table_rows_in_order(
          ["", "Ending balance", "", "", "£273.45", ""],
          ["15th May 2014", "Transaction on day 15.", "", "£10.00", "£273.45", "Edit Delete"],
          ["14th May 2014", "Transaction on day 14.", "", "£10.00", "£263.45", "Edit Delete"],
          ["13th May 2014", "Transaction on day 13.", "", "£10.00", "£253.45", "Edit Delete"],
          ["12th May 2014", "Transaction on day 12.", "", "£10.00", "£243.45", "Edit Delete"],
          ["11th May 2014", "Transaction on day 11.", "", "£10.00", "£233.45", "Edit Delete"],
          ["10th May 2014", "Transaction on day 10.", "", "£10.00", "£223.45", "Edit Delete"],
          ["9th May 2014", "Transaction on day 9.", "", "£10.00", "£213.45", "Edit Delete"],
          ["8th May 2014", "Transaction on day 8.", "", "£10.00", "£203.45", "Edit Delete"],
          ["7th May 2014", "Transaction on day 7.", "", "£10.00", "£193.45", "Edit Delete"],
          ["6th May 2014", "Transaction on day 6.", "", "£10.00", "£183.45", "Edit Delete"],
          ["", "Starting balance", "", "", "£173.45", ""]
        )

        within '.pagination' do
          expect(page).to have_link("2", href: account_transactions_path(@account, page: 2))
          expect(page).to have_link("Next")
          expect(page).to have_link("Last")
        end

        click_link "Next"

        expect(page).to have_table_rows_in_order(
          ["", "Ending balance", "", "", "£173.45", ""],
          ["5th May 2014", "Transaction on day 5.", "", "£10.00", "£173.45", "Edit Delete"],
          ["4th May 2014", "Transaction on day 4.", "", "£10.00", "£163.45", "Edit Delete"],
          ["3rd May 2014", "Transaction on day 3.", "", "£10.00", "£153.45", "Edit Delete"],
          ["2nd May 2014", "Transaction on day 2.", "", "£10.00", "£143.45", "Edit Delete"],
          ["1st May 2014", "Transaction on day 1.", "", "£10.00", "£133.45", "Edit Delete"],
          ["", "Starting balance", "", "", "£123.45", ""]
        )

        within '.pagination' do
          expect(page).to have_link("First")
          expect(page).to have_link("Prev")
          expect(page).to have_link("1", href: account_transactions_path(@account))
        end
      end

      scenario "Viewing an empty list of transactions" do
        visit account_transactions_path(@account)

        expect(page).to have_content("My Account")
        expect(page).to have_content("Transactions")

        expect(page).to have_content("You have no transactions. Try adding one here.")
        expect(page).to have_link("here", href: new_account_transaction_path(@account))
      end

      scenario "Adding a transaction to an account" do
        Timecop.freeze(2014, 1, 1) do
          visit accounts_path

          click_link "My Account"

          expect(page).to have_link("Add transaction", href: new_account_transaction_path(@account))

          click_link "Add transaction"

          expect(page).to have_content("New Transaction")

          expect(page).to have_field("Description")
          expect(page).to have_field("Amount")
          expect(page).to have_field("Transaction date", with: "01-01-2014")

          click_button "Create Transaction"

          expect(page).to have_content("Transaction not created.")
          within ".transaction_description" do
            expect(page).to have_content("can't be blank")
          end
          within ".transaction_amount" do
            expect(page).to have_content("can't be blank")
          end

          fill_in "Description", with: "An Example Transaction"
          fill_in "Amount", with: 20.11
          click_button "Create Transaction"

          expect(current_path).to eq account_transactions_path(@account)
          expect(page).to have_content("Transaction successfully created.")
          expect(page).to have_content("My Account")
          expect(page).to have_content("Transactions")

          expect(page).to have_table_rows_in_order(
            ["", "Ending balance", "", "", "£143.56", ""],
            ["1st January 2014", "An Example Transaction", "", "£20.11", "£143.56", "Edit Delete"],
            ["", "Starting balance", "", "", "£123.45", ""]
          )
        end
      end

      scenario "Editing an existing transaction" do
        transaction = FactoryGirl.create(:transaction, description: "A Transaction", amount: 24, account: @account, transaction_date: "02-01-2014")

        visit account_transactions_path(@account)

        expect(page).to have_table_rows_in_order(
          ["", "Ending balance", "", "", "£147.45", ""],
          ["2nd January 2014", "A Transaction", "", "£24.00", "£147.45", "Edit Delete"],
          ["", "Starting balance", "", "", "£123.45", ""]
        )

        expect(page).to have_link("Edit")
        click_link "Edit"

        expect(current_path).to eq edit_account_transaction_path(@account, transaction)

        expect(page).to have_content("Edit Transaction")
        expect(page).to have_field("Description", with: "A Transaction")
        expect(page).to have_field("Amount", with: "24.00")
        expect(page).to have_field("Transaction date", with: "02-01-2014")

        fill_in "Description", with: ""
        fill_in "Transaction date", with: ""
        click_button "Update Transaction"

        expect(page).to have_content("Transaction not updated.")
        within ".transaction_description" do
          expect(page).to have_content("can't be blank")
        end

        fill_in "Description", with: "Edited Transaction"
        fill_in "Amount", with: 58.65
        fill_in "Transaction date", with: "04-01-2014"
        click_button "Update Transaction"

        expect(current_path).to eq account_transactions_path(@account)
        expect(page).to have_content("Transaction successfully updated.")

        expect(page).to have_table_rows_in_order(
          ["", "Ending balance", "", "", "£182.10", ""],
          ["4th January 2014", "Edited Transaction", "", "£58.65", "£182.10", "Edit Delete"],
          ["", "Starting balance", "", "", "£123.45", ""]
        )
      end

      scenario "Deleting a transaction" do
        FactoryGirl.create(:transaction, description: "A Transaction", amount: 24, account: @account, transaction_date: "09-04-2014")
        FactoryGirl.create(:transaction, description: "An Old Transaction", amount: 34, account: @account, transaction_date: "08-04-2014")

        visit account_transactions_path(@account)

        expect(page).to have_table_rows_in_order(
          ["", "Ending balance", "", "", "£181.45", ""],
          ["9th April 2014", "A Transaction", "", "£24.00", "£181.45", "Edit Delete"],
          ["8th April 2014", "An Old Transaction", "", "£34.00", "£157.45", "Edit Delete"],
          ["", "Starting balance", "", "", "£123.45", ""]
        )

        within 'tbody tr:nth-child(3)' do
          click_link "Delete"
        end

        expect(current_path).to eq account_transactions_path(@account)
        expect(page).to_not have_content("Old Transaction")
        expect(page).to_not have_content("£34.00")

        expect(page).to have_table_rows_in_order(
          ["", "Ending balance", "", "", "£147.45", ""],
          ["9th April 2014", "A Transaction", "", "£24.00", "£147.45", "Edit Delete"],
          ["", "Starting balance", "", "", "£123.45", ""]
        )

        expect(page).to have_content("Transaction successfully deleted.")
      end
    end

    context "without access" do
      before do
        @account = FactoryGirl.create(:account)
      end

      scenario "Trying to view transactions" do
        visit account_transactions_path(@account)

        expect(current_path).to eq accounts_path

        expect(page).to have_content("Account could not be found.")
      end

      scenario "Trying to add a transaction" do
        visit new_account_transaction_path(@account)

        expect(current_path).to eq accounts_path

        expect(page).to have_content("Account could not be found.")
      end

      scenario "Trying to edit a transaction" do
        transaction = FactoryGirl.create(:transaction, account: @account)

        visit edit_account_transaction_path(@account, transaction)

        expect(current_path).to eq accounts_path

        expect(page).to have_content("Account could not be found.")
      end
    end
  end
end
