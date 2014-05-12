require 'spec_helper'

feature "Transactions", %q{

} do

  context "As a non-logged in user" do
    before do
      @account = FactoryGirl.create(:account)
    end
    scenario "Trying to view transactions for an account" do
      visit account_path(@account)

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
        @account = FactoryGirl.create(:account, name: "My Account", user: @user)
      end

      scenario "Viewing transactions for an account" do
        @account.transactions << [FactoryGirl.create(:transaction, description: "Example Transaction", amount: 30.48),
                                 FactoryGirl.create(:transaction, description: "Another Transaction", amount: 12.34)]

        visit accounts_path

        click_link "My Account"

        expect(current_path).to eq account_path(@account)

        expect(page).to have_content("My Account")
        expect(page).to have_content("Transactions")

        expect(page).to have_content("Example Transaction")
        expect(page).to have_content("Another Transaction")

        expect(page).to have_content("£30.48")
        expect(page).to have_content("£12.34")
      end

      scenario "Viewing an empty list of transactions" do
        visit account_path(@account)

        expect(page).to have_content("My Account")
        expect(page).to have_content("Transactions")

        expect(page).to have_content("You have no transactions. Try adding one here.")
        expect(page).to have_link("here", href: new_account_transaction_path(@account))
      end

      scenario "Adding a transaction to an account" do
        visit accounts_path

        click_link "My Account"

        expect(page).to have_link("Add Transaction", href: new_account_transaction_path(@account))

        click_link "Add Transaction"

        expect(page).to have_content("New Transaction")

        expect(page).to have_field("Description")
        expect(page).to have_field("Amount")

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

        expect(current_path).to eq account_path(@account)
        expect(page).to have_content("Transaction successfully created.")
        expect(page).to have_content("My Account")
        expect(page).to have_content("An Example Transaction")
      end

      scenario "Editing an existing transaction" do
        transaction = FactoryGirl.create(:transaction, description: "A Transaction", amount: 24, account: @account)

        visit account_path(@account)

        expect(page).to have_content("A Transaction - £24.00")
        expect(page).to have_link("Edit")
        click_link "Edit"

        expect(current_path).to eq edit_account_transaction_path(@account, transaction)

        expect(page).to have_content("Edit Transaction")
        expect(page).to have_field("Description", with: "A Transaction")
        expect(page).to have_field("Amount", with: "24.0")

        fill_in "Description", with: ""
        click_button "Update Transaction"

        expect(page).to have_content("Transaction not updated.")
        within ".transaction_description" do
          expect(page).to have_content("can't be blank")
        end

        fill_in "Description", with: "Edited Transaction"
        fill_in "Amount", with: 58.65
        click_button "Update Transaction"

        expect(current_path).to eq account_path(@account)
        expect(page).to have_content("Transaction successfully updated.")
        expect(page).to have_content("Edited Transaction - £58.65")
      end
    end

    context "without access" do
      before do
        @account = FactoryGirl.create(:account)
      end

      scenario "Trying to view transactions" do
        visit account_path(@account)

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
