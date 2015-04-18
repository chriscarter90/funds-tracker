require 'rails_helper'

feature "Transfers", %q{

} do

  context "As a non-logged in user" do
    before do
      @account = FactoryGirl.create(:account)
    end

    scenario "Trying to add a transfer to an account" do
      visit new_account_transfer_path(@account)

      expect(current_path).to eq new_user_session_path

      expect(page).to have_content("You need to sign in or sign up before continuing.")
    end

    scenario "Trying to edit an existing transfer" do
      transfer = FactoryGirl.create(:transfer,
                                   account_transaction: FactoryGirl.create(:account_transaction,
                                                                           account: @account)
                                  )

      visit edit_account_transfer_path(@account, transfer)

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

        @transfer_account = FactoryGirl.create(:account, name: "Transfer Account", user: @user)
      end

      scenario "Adding a transfer to an account" do
        Timecop.freeze(2014, 1, 1) do
          visit accounts_path

          click_link "My Account"

          expect(page).to have_link("Add Transfer", href: new_account_transfer_path(@account))

          click_link "Add Transfer"

          expect(page).to have_content("New Transfer")

          expect(page).to have_select("Other account", options: ["-- Select an account --", "Transfer Account"])
          expect(page).to have_field("Amount")
          expect(page).to have_field("Transaction date", with: "01-01-2014")

          fill_in "Amount", with: 20.15

          click_button "Create Transfer"

          expect(page).to have_content("Transfer not created.")
          within ".transfer_other_account" do
            expect(page).to have_content("can't be blank")
          end

          select "Transfer Account", from: "Other account"
          click_button "Create Transfer"

          expect(current_path).to eq account_account_transactions_path(@account)
          expect(page).to have_content("Transfer successfully created.")
          expect(page).to have_content("My Account")
          expect(page).to have_content("Transactions")

          expect(page).to have_table_rows_in_order(
            ["", "Ending balance", "", "", "£143.60", ""],
            ["1st January 2014", "Money transferred between ##{@account.id} and ##{@transfer_account.id}.", "TAGS GO HERE", "£20.15", "£143.60", "Edit Delete"],
            ["", "Starting balance", "", "", "£123.45", ""]
          )
        end
      end

      scenario "Editing an existing transfer" do
        transfer = FactoryGirl.create(:transfer,
                                     other_account: @transfer_account,
                                     account_transaction: FactoryGirl.create(:account_transaction,
                                                                             amount: 25,
                                                                             account: @account,
                                                                             transaction_date: "02-03-2014")
                                    )

        visit account_account_transactions_path(@account)

        expect(page).to have_table_rows_in_order(
          ["", "Ending balance", "", "", "£148.45", ""],
          ["2nd March 2014", "Money transferred between ##{@account.id} and ##{@transfer_account.id}.", "TAGS GO HERE", "£25.00", "£148.45", "Edit Delete"],
          ["", "Starting balance", "", "", "£123.45", ""]
        )

        expect(page).to have_link("Edit")
        click_link "Edit"

        expect(current_path).to eq edit_account_transfer_path(@account, transfer)

        expect(page).to have_content("Edit Transfer")
        expect(page).to have_select("Other account", options: ["-- Select an account --", "Transfer Account"], selected: "Transfer Account")
        expect(page).to have_field("Amount", with: "25.00")
        expect(page).to have_field("Transaction date", with: "02-03-2014")

        select "-- Select an account --", from: "Other account"
        fill_in "Transaction date", with: ""
        click_button "Update Transfer"

        expect(page).to have_content("Transfer not updated.")
        within ".transfer_other_account" do
          expect(page).to have_content("can't be blank")
        end

        within ".transfer_account_transaction_transaction_date" do
          expect(page).to have_content("can't be blank")
        end

        select "Transfer Account", from: "Other account"
        fill_in "Amount", with: 58.00
        fill_in "Transaction date", with: "04-03-2014"
        click_button "Update Transfer"

        expect(current_path).to eq account_account_transactions_path(@account)
        expect(page).to have_content("Transfer successfully updated.")

        expect(page).to have_table_rows_in_order(
          ["", "Ending balance", "", "", "£181.45", ""],
          ["4th March 2014", "Money transferred between ##{@account.id} and ##{@transfer_account.id}.", "TAGS GO HERE", "£58.00", "£181.45", "Edit Delete"],
          ["", "Starting balance", "", "", "£123.45", ""]
        )
      end

      scenario "Deleting a transfer" do
        FactoryGirl.create(:transfer,
                           other_account: @transfer_account,
                           account_transaction: FactoryGirl.create(:account_transaction,
                                                                   amount: 24,
                                                                   account: @account,
                                                                   transaction_date: "09-04-2014")
                          )

        FactoryGirl.create(:transfer,
                           other_account: @transfer_account,
                           account_transaction: FactoryGirl.create(:account_transaction,
                                                                   amount: 34,
                                                                   account: @account,
                                                                   transaction_date: "08-04-2014")
                          )

        visit account_account_transactions_path(@account)

        expect(page).to have_table_rows_in_order(
          ["", "Ending balance", "", "", "£181.45", ""],
          ["9th April 2014", "Money transferred between ##{@account.id} and ##{@transfer_account.id}.", "TAGS GO HERE", "£24.00", "£181.45", "Edit Delete"],
          ["8th April 2014", "Money transferred between ##{@account.id} and ##{@transfer_account.id}.", "TAGS GO HERE", "£34.00", "£157.45", "Edit Delete"],
          ["", "Starting balance", "", "", "£123.45", ""]
        )

        within 'tbody tr:nth-child(3)' do
          click_link "Delete"
        end

        expect(current_path).to eq account_account_transactions_path(@account)
        expect(page).to have_content("Money transferred between ##{@account.id} and ##{@transfer_account.id}.", count: 1)
        expect(page).to_not have_content("£34.00")

        expect(page).to have_table_rows_in_order(
          ["", "Ending balance", "", "", "£147.45", ""],
          ["9th April 2014", "Money transferred between ##{@account.id} and ##{@transfer_account.id}.", "TAGS GO HERE", "£24.00", "£147.45", "Edit Delete"],
          ["", "Starting balance", "", "", "£123.45", ""]
        )

        expect(page).to have_content("Transfer successfully deleted.")
      end
    end

    context "without access" do
      before do
        @account = FactoryGirl.create(:account)
      end

      scenario "Trying to add a transaction" do
        visit new_account_transfer_path(@account)

        expect(current_path).to eq accounts_path

        expect(page).to have_content("Account could not be found.")
      end

      scenario "Trying to edit a payment" do
        transfer = FactoryGirl.create(:transfer,
                                     account_transaction: FactoryGirl.create(:account_transaction,
                                                                             account: @account)
                                    )

        visit edit_account_transfer_path(@account, transfer)

        expect(current_path).to eq accounts_path

        expect(page).to have_content("Account could not be found.")
      end
    end
  end
end
