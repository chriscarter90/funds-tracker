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
      ["", "Ending balance", "", "", "£30.00", ""],
      ["1st January 2014", "A Transaction", "Food", "£20.00", "£30.00", "Edit Delete"],
      ["", "Starting balance", "", "", "£10.00", ""]
    )

    click_link "Edit"

    select "-- Select a tag --", from: "Tag"

    click_button "Update Transaction"

    expect(current_path).to eq account_transactions_path(account)

    expect(page).to have_table_rows_in_order(
      ["", "Ending balance", "", "", "£30.00", ""],
      ["1st January 2014", "A Transaction", "", "£20.00", "£30.00", "Edit Delete"],
      ["", "Starting balance", "", "", "£10.00", ""]
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
      ["", "Ending balance", "", "", "£100.00", ""],
      ["3rd January 2014", "Water #1", "Water", "£40.00", "£100.00", "Edit Delete"],
      ["2nd January 2014", "Food #2", "Food", "£30.00", "£60.00", "Edit Delete"],
      ["1st January 2014", "Food #1", "Food", "£20.00", "£30.00", "Edit Delete"],
      ["", "Starting balance", "", "", "£10.00", ""]
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
      ["", "Ending balance", "", "£40.00", ""],
      ["3rd January 2014", "Water #1", "£40.00", "£40.00", "Edit Delete"],
      ["", "Starting balance", "", "£0.00", ""]
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
      ["", "Ending balance", "", "£50.00", ""],
      ["2nd January 2014", "Food #2", "£30.00", "£50.00", "Edit Delete"],
      ["1st January 2014", "Food #1", "£20.00", "£20.00", "Edit Delete"],
      ["", "Starting balance", "", "£0.00", ""]
    )

    visit tagged_account_transactions_path(account, other_tag)

    expect(page).to have_content("My Account")
    expect(page).to have_content("Transactions tagged with Other")

    expect(page).to have_content("No transactions tagged with Other found.")
    expect(page).to have_content("Try adding one here.")
    expect(page).to have_link("here", href: new_account_transaction_path(account))
  end

  scenario "Viewing tagged transactions for a single account with pagination" do
    user = FactoryGirl.create(:user)
    sign_in_as user

    a_tag = FactoryGirl.create(:tag, name: "Stuff", user: user)

    account = FactoryGirl.create(:account, user: user)

    1.upto(15) do |i|
      account.transactions << FactoryGirl.create(:transaction, description: "Transaction on day #{i}.", transaction_date: "#{i}-05-2014", amount: 10, tag: a_tag)
    end

    visit tagged_account_transactions_path(account, a_tag)

    expect(page).to have_table_rows_in_order(
      ["", "Ending balance", "", "£150.00", ""],
      ["15th May 2014", "Transaction on day 15.", "£10.00", "£150.00", "Edit Delete"],
      ["14th May 2014", "Transaction on day 14.", "£10.00", "£140.00", "Edit Delete"],
      ["13th May 2014", "Transaction on day 13.", "£10.00", "£130.00", "Edit Delete"],
      ["12th May 2014", "Transaction on day 12.", "£10.00", "£120.00", "Edit Delete"],
      ["11th May 2014", "Transaction on day 11.", "£10.00", "£110.00", "Edit Delete"],
      ["10th May 2014", "Transaction on day 10.", "£10.00", "£100.00", "Edit Delete"],
      ["9th May 2014", "Transaction on day 9.", "£10.00", "£90.00", "Edit Delete"],
      ["8th May 2014", "Transaction on day 8.", "£10.00", "£80.00", "Edit Delete"],
      ["7th May 2014", "Transaction on day 7.", "£10.00", "£70.00", "Edit Delete"],
      ["6th May 2014", "Transaction on day 6.", "£10.00", "£60.00", "Edit Delete"],
      ["", "Starting balance", "", "£50.00", ""]
    )

    within '.pagination' do
      expect(page).to have_link("2", href: tagged_account_transactions_path(account, a_tag, page: 2))
      expect(page).to have_link("Next")
      expect(page).to have_link("Last")
    end

    click_link "Next"

    expect(page).to have_table_rows_in_order(
      ["", "Ending balance", "", "£50.00", ""],
      ["5th May 2014", "Transaction on day 5.", "£10.00", "£50.00", "Edit Delete"],
      ["4th May 2014", "Transaction on day 4.", "£10.00", "£40.00", "Edit Delete"],
      ["3rd May 2014", "Transaction on day 3.", "£10.00", "£30.00", "Edit Delete"],
      ["2nd May 2014", "Transaction on day 2.", "£10.00", "£20.00", "Edit Delete"],
      ["1st May 2014", "Transaction on day 1.", "£10.00", "£10.00", "Edit Delete"],
      ["", "Starting balance", "", "£0.00", ""]
    )

    within '.pagination' do
      expect(page).to have_link("First")
      expect(page).to have_link("Prev")
      expect(page).to have_link("1", href: tagged_account_transactions_path(account, a_tag))
    end
  end

  scenario "Viewing tagged transaction across all accounts" do
    user = FactoryGirl.create(:user)
    sign_in_as user

    food_tag = FactoryGirl.create(:tag, name: "Food", user: user)
    water_tag = FactoryGirl.create(:tag, name: "Water", user: user)
    other_tag = FactoryGirl.create(:tag, name: "Other", user: user)

    account_1 = FactoryGirl.create(:account, name: "Account #1", user: user)
    account_1.transactions << [
      FactoryGirl.create(:transaction, description: "Food #1", amount: 20, tag: food_tag, transaction_date: "01-01-2014"),
      FactoryGirl.create(:transaction, description: "Food #2", amount: 30, tag: food_tag, transaction_date: "02-01-2014"),
      FactoryGirl.create(:transaction, description: "Water #1", amount: 40, tag: water_tag, transaction_date: "03-01-2014"),
    ]

    account_2 = FactoryGirl.create(:account, name: "Account #2", user: user)
    account_2.transactions << [
      FactoryGirl.create(:transaction, description: "Food #3", amount: 50, tag: food_tag, transaction_date: "07-01-2014"),
      FactoryGirl.create(:transaction, description: "Water #2", amount: 45, tag: water_tag, transaction_date: "08-01-2014")
    ]

    visit accounts_path

    within ".tags" do
      expect(page).to have_link("Food", href: tagged_accounts_path(food_tag))
      click_link "Food"
    end

    expect(current_path).to eq tagged_accounts_path(food_tag)

    expect(page).to have_content("All Accounts")
    expect(page).to have_content("Transactions tagged with Food")

    expect(page).to have_table_columns(["Transaction date", "Description", "Account", "Amount", "Running total", "Actions"])

    expect(page).to have_table_rows_in_order(
      ["", "Ending balance", "", "", "£100.00", ""],
      ["7th January 2014", "Food #3", "Account #2", "£50.00", "£100.00", "Edit Delete"],
      ["2nd January 2014", "Food #2", "Account #1", "£30.00", "£50.00", "Edit Delete"],
      ["1st January 2014", "Food #1", "Account #1", "£20.00", "£20.00", "Edit Delete"],
      ["", "Starting balance", "", "", "£0.00", ""]
    )

    visit accounts_path

    within ".tags" do
      expect(page).to have_link("Water", href: tagged_accounts_path(water_tag))
      click_link "Water"
    end

    expect(current_path).to eq tagged_accounts_path(water_tag)

    expect(page).to have_content("All Accounts")
    expect(page).to have_content("Transactions tagged with Water")

    expect(page).to have_table_rows_in_order(
      ["", "Ending balance", "", "", "£85.00", ""],
      ["8th January 2014", "Water #2", "Account #2", "£45.00", "£85.00", "Edit Delete"],
      ["3rd January 2014", "Water #1", "Account #1", "£40.00", "£40.00", "Edit Delete"],
      ["", "Starting balance", "", "", "£0.00", ""]
    )

    expect(page).to have_link("Account #1", href: account_transactions_path(account_1))
    expect(page).to have_link("Account #2", href: account_transactions_path(account_2))

    visit tagged_accounts_path(other_tag)

    expect(page).to have_content("All Accounts")
    expect(page).to have_content("Transactions tagged with Other")

    expect(page).to have_content("No transactions tagged with Other found.")
    expect(page).to have_content("Try adding one to an account.")
  end
end
