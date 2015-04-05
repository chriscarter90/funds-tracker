class RenameTransactionsTable < ActiveRecord::Migration
  def change
    rename_table :transactions, :account_transactions
  end
end
