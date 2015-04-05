class ChangeTransactionIdOnTransfersAndPayments < ActiveRecord::Migration
  def change
    rename_column :payments, :transaction_id, :account_transaction_id
    rename_column :transfers, :transaction_id, :account_transaction_id
  end
end
