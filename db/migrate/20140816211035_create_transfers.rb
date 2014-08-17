class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.integer :to_account_id
      t.integer :from_account_id
      t.decimal :amount
      t.date :transfer_date

      t.timestamps
    end
  end
end
