require 'spec_helper'

feature "Tagging transactions", %q{

} do

  scenario "Tagging a transaction" do
    user = FactoryGirl.create(:user)
    sign_in_as user

    account = FactoryGirl.create(:account, user: user, starting_balance: 10)
    transaction = FactoryGirl.create(:transaction, description: "A Transaction", account: account, amount: 20, transaction_date: "01-01-2014")

    FactoryGirl.create(:tag, name: "Food", user: user)
    FactoryGirl.create(:tag, name: "Water", user: user)
    FactoryGirl.create(:tag, name: "Other Stuff")

    visit edit_account_transaction_path(account, transaction)

    expect(page).to have_select("Tag", options: ["-- Select a tag --", "Food", "Water"])

    select "Food", from: "Tag"

    click_button "Update Transaction"

    expect(current_path).to eq account_transactions_path(account)

    expect(page).to have_content("Transaction successfully updated.")

    expect(page).to have_table_rows_in_order(
      ["", "Starting balance", "", "", "£10.00", ""],
      ["1st January 2014", "A Transaction", "Food", "£20.00", "£30.00", "Edit Delete"],
      ["", "Current balance", "", "", "£30.00", ""]
    )

    click_link "Edit"

    select "-- Select a tag --", from: "Tag"

    click_button "Update Transaction"

    expect(current_path).to eq account_transactions_path(account)

    expect(page).to have_table_rows_in_order(
      ["", "Starting balance", "", "", "£10.00", ""],
      ["1st January 2014", "A Transaction", "", "£20.00", "£30.00", "Edit Delete"],
      ["", "Current balance", "", "", "£30.00", ""]
    )
  end

  scenario "Viewing tagged transactions for a single account" do
    user = FactoryGirl.create(:user)
    sign_in_as user

    food_tag = FactoryGirl.create(:tag, name: "Food", user: user)
    water_tag = FactoryGirl.create(:tag, name: "Water", user: user)
    other_tag = FactoryGirl.create(:tag, name: "Other", user: user)

    account = FactoryGirl.create(:account, name: "My Account", user: user, starting_balance: 10)
    account.transactions << [
      FactoryGirl.create(:transaction, description: "Food #1", amount: 20, tag: food_tag, transaction_date: "01-01-2014"),
      FactoryGirl.create(:transaction, description: "Food #2", amount: 30, tag: food_tag, transaction_date: "02-01-2014"),
      FactoryGirl.create(:transaction, description: "Water #1", amount: 40, tag: water_tag, transaction_date: "03-01-2014")
    ]

    visit account_transactions_path(account)

    expect(page).to have_table_rows_in_order(
      ["", "Starting balance", "", "", "£10.00", ""],
      ["3rd January 2014", "Water #1", "Water", "£40.00", "£50.00", "Edit Delete"],
      ["2nd January 2014", "Food #2", "Food", "£30.00", "£80.00", "Edit Delete"],
      ["1st January 2014", "Food #1", "Food", "£20.00", "£100.00", "Edit Delete"],
      ["", "Current balance", "", "", "£100.00", ""]
    )

    within "tr:nth-child(2)" do
      expect(page).to have_link("Water", href: tagged_account_transactions_path(account, water_tag))
    end

    within ".tags" do
      expect(page).to have_link("Water", href: tagged_account_transactions_path(account, water_tag))
      click_link "Water"
    end

    expect(current_path).to eq tagged_account_transactions_path(account, water_tag)

    expect(page).to have_content("My Account")
    expect(page).to have_content("Transactions tagged with Water")

    expect(page).to have_table_columns(["Transaction date", "Description",  "Amount", "Running total", "Actions"])

    expect(page).to have_table_rows_in_order(
      ["3rd January 2014", "Water #1", "£40.00", "£40.00", "Edit Delete"],
      ["", "Total", "", "£40.00", ""]
    )

    visit account_transactions_path(account)

    within "tr:nth-child(3)" do
      expect(page).to have_link("Food", href: tagged_account_transactions_path(account, food_tag))
    end

    within ".tags" do
      expect(page).to have_link("Food", href: tagged_account_transactions_path(account, food_tag))
      click_link "Food"
    end

    expect(current_path).to eq tagged_account_transactions_path(account, food_tag)

    expect(page).to have_content("My Account")
    expect(page).to have_content("Transactions tagged with Food")

    expect(page).to have_table_rows_in_order(
      ["2nd January 2014", "Food #2", "£30.00", "£30.00", "Edit Delete"],
      ["1st January 2014", "Food #1", "£20.00", "£50.00", "Edit Delete"],
      ["", "Total", "", "£50.00", ""]
    )

    visit tagged_account_transactions_path(account, other_tag)

    expect(page).to have_content("My Account")
    expect(page).to have_content("Transactions tagged with Other")

    expect(page).to have_content("No transactions tagged with Other found.")
    expect(page).to have_content("Try adding one here.")
    expect(page).to have_link("here", href: new_account_transaction_path(account))
  end
end
