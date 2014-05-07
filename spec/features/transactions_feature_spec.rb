require 'spec_helper'

feature "Transactions", %q{

} do

  context "As a non-logged in user" do
    scenario "Trying to view transactions for an account" do
      account = FactoryGirl.create(:account)

      visit account_path(account)

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
      scenario "Viewing transactions for an account" do
        account = FactoryGirl.create(:account, name: "My Account", user: @user)
        account.transactions << [FactoryGirl.create(:transaction, description: "Example Transaction", amount: 30.48),
                                 FactoryGirl.create(:transaction, description: "Another Transaction", amount: 12.34)]

        visit accounts_path

        click_link "My Account"

        expect(current_path).to eq account_path(account)

        expect(page).to have_content("My Account")
        expect(page).to have_content("Transactions")

        expect(page).to have_content("Example Transaction")
        expect(page).to have_content("Another Transaction")

        expect(page).to have_content("£30.48")
        expect(page).to have_content("£12.34")
      end
    end

    context "without access" do
      scenario "Trying to view transactions" do
        account = FactoryGirl.create(:account)
        account.transactions << [FactoryGirl.create(:transaction, description: "Example Transaction", amount: 30.48),
                                 FactoryGirl.create(:transaction, description: "Another Transaction", amount: 12.34)]

        visit account_path(account)

        expect(current_path).to eq accounts_path

        expect(page).to have_content("Account could not be found.")
      end
    end
  end

end
