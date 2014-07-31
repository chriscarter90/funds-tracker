class ChangeTransactionDatetimeToDate < ActiveRecord::Migration
  def up
    change_column :transactions, :transaction_date, :date
  end

  def down
    change_column :transactions, :transaction_date, :datetime
  end
end
