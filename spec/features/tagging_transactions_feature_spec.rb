require 'spec_helper'

feature "Tagging transactions", %q{

} do

  scenario "Tagging a transaction" do
    user = FactoryGirl.create(:user)
    sign_in_as user

    account = FactoryGirl.create(:account, user: user)
    transaction = FactoryGirl.create(:transaction, description: "A Transaction", account: account)

    FactoryGirl.create(:tag, name: "Food", user: user)
    FactoryGirl.create(:tag, name: "Water", user: user)
    FactoryGirl.create(:tag, name: "Other Stuff")

    visit account_path(account)

    expect(page).to have_content("A Transaction")

    click_link "Edit"

    expect(page).to have_select("Tag", options: ["-- Select a tag --", "Food", "Water"])

    select "Food", from: "Tag"

    click_button "Update Transaction"

    expect(current_path).to eq account_path(account)

    expect(page).to have_content("Transaction successfully updated.")

    expect(page).to have_content("Food")

    click_link "Edit"

    select "-- Select a tag --", from: "Tag"

    click_button "Update Transaction"

    expect(current_path).to eq account_path(account)

    expect(page).to_not have_content("Food")
  end
end
