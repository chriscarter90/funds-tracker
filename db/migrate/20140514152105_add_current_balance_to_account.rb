class AddCurrentBalanceToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :current_balance, :decimal
  end
end
