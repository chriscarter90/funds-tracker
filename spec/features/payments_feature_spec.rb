require 'rails_helper'

feature "Payments", %q{

} do

  context "As a non-logged in user" do
    before do
      @account = FactoryGirl.create(:account)
    end

    scenario "Trying to add a payment to an account" do
      visit new_account_payment_path(@account)

      expect(current_path).to eq new_user_session_path

      expect(page).to have_content("You need to sign in or sign up before continuing.")
    end

    scenario "Trying to edit an existing payment" do
      payment = FactoryGirl.create(:payment,
                                   account_transaction: FactoryGirl.create(:account_transaction,
                                                                           account: @account)
                                  )

      visit edit_account_payment_path(@account, payment)

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

      scenario "Adding a payment to an account" do
        Timecop.freeze(2014, 1, 1) do
          visit accounts_path

          click_link "My Account"

          expect(page).to have_link("Add Payment", href: new_account_payment_path(@account))

          click_link "Add Payment"

          expect(page).to have_content("New Payment")

          expect(page).to have_field("Description")
          expect(page).to have_field("Amount")
          expect(page).to have_field("Transaction date", with: "01-01-2014")

          click_button "Create Payment"

          expect(page).to have_content("Payment not created.")
          within ".payment_description" do
            expect(page).to have_content("can't be blank")
          end
          within ".payment_account_transaction_amount" do
            expect(page).to have_content("can't be blank")
          end

          fill_in "Description", with: "An Example Payment"
          fill_in "Amount", with: 20.11
          click_button "Create Payment"

          expect(current_path).to eq account_account_transactions_path(@account)
          expect(page).to have_content("Payment successfully created.")
          expect(page).to have_content("My Account")
          expect(page).to have_content("Transactions")

          expect(page).to have_table_rows_in_order(
            ["", "Ending balance", "", "", "£143.56", ""],
            ["1st January 2014", "An Example Payment", "TAGS GO HERE", "£20.11", "£143.56", "Edit Delete"],
            ["", "Starting balance", "", "", "£123.45", ""]
          )
        end
      end

      scenario "Editing an existing payment" do
        payment = FactoryGirl.create(:payment,
                                     description: "A Payment",
                                     account_transaction: FactoryGirl.create(:account_transaction,
                                                                             amount: 24,
                                                                             account: @account,
                                                                             transaction_date: "02-01-2014")
                                    )

        visit account_account_transactions_path(@account)

        expect(page).to have_table_rows_in_order(
          ["", "Ending balance", "", "", "£147.45", ""],
          ["2nd January 2014", "A Payment", "TAGS GO HERE", "£24.00", "£147.45", "Edit Delete"],
          ["", "Starting balance", "", "", "£123.45", ""]
        )

        expect(page).to have_link("Edit")
        click_link "Edit"

        expect(current_path).to eq edit_account_payment_path(@account, payment)

        expect(page).to have_content("Edit Payment")
        expect(page).to have_field("Description", with: "A Payment")
        expect(page).to have_field("Amount", with: "24.00")
        expect(page).to have_field("Transaction date", with: "02-01-2014")

        fill_in "Description", with: ""
        fill_in "Transaction date", with: ""
        click_button "Update Payment"

        expect(page).to have_content("Payment not updated.")
        within ".payment_description" do
          expect(page).to have_content("can't be blank")
        end

        fill_in "Description", with: "Edited Payment"
        fill_in "Amount", with: 58.65
        fill_in "Transaction date", with: "04-01-2014"
        click_button "Update Payment"

        expect(current_path).to eq account_account_transactions_path(@account)
        expect(page).to have_content("Payment successfully updated.")

        expect(page).to have_table_rows_in_order(
          ["", "Ending balance", "", "", "£182.10", ""],
          ["4th January 2014", "Edited Payment", "TAGS GO HERE", "£58.65", "£182.10", "Edit Delete"],
          ["", "Starting balance", "", "", "£123.45", ""]
        )
      end

      scenario "Deleting a payment" do
        FactoryGirl.create(:payment,
                           description: "A Payment",
                           account_transaction: FactoryGirl.create(:account_transaction,
                                                                   amount: 24,
                                                                   account: @account,
                                                                   transaction_date: "09-04-2014")
                          )

        FactoryGirl.create(:payment,
                           description: "An Old Payment",
                           account_transaction: FactoryGirl.create(:account_transaction,
                                                                   amount: 34,
                                                                   account: @account,
                                                                   transaction_date: "08-04-2014")
                          )

        visit account_account_transactions_path(@account)

        expect(page).to have_table_rows_in_order(
          ["", "Ending balance", "", "", "£181.45", ""],
          ["9th April 2014", "A Payment", "TAGS GO HERE", "£24.00", "£181.45", "Edit Delete"],
          ["8th April 2014", "An Old Payment", "TAGS GO HERE", "£34.00", "£157.45", "Edit Delete"],
          ["", "Starting balance", "", "", "£123.45", ""]
        )

        within 'tbody tr:nth-child(3)' do
          click_link "Delete"
        end

        expect(current_path).to eq account_account_transactions_path(@account)
        expect(page).to_not have_content("Old Payment")
        expect(page).to_not have_content("£34.00")

        expect(page).to have_table_rows_in_order(
          ["", "Ending balance", "", "", "£147.45", ""],
          ["9th April 2014", "A Payment", "TAGS GO HERE", "£24.00", "£147.45", "Edit Delete"],
          ["", "Starting balance", "", "", "£123.45", ""]
        )

        expect(page).to have_content("Payment successfully deleted.")
      end
    end

    context "without access" do
      before do
        @account = FactoryGirl.create(:account)
      end

      scenario "Trying to add a transaction" do
        visit new_account_payment_path(@account)

        expect(current_path).to eq accounts_path

        expect(page).to have_content("Account could not be found.")
      end

      scenario "Trying to edit a payment" do
        payment = FactoryGirl.create(:payment,
                                     account_transaction: FactoryGirl.create(:account_transaction,
                                                                             account: @account)
                                    )

        visit edit_account_payment_path(@account, payment)

        expect(current_path).to eq accounts_path

        expect(page).to have_content("Account could not be found.")
      end
    end
  end
end
