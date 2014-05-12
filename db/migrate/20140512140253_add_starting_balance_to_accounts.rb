class AddStartingBalanceToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :starting_balance, :decimal
  end
end
