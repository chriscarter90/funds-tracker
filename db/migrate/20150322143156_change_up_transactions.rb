class ChangeUpTransactions < ActiveRecord::Migration
  def up
    remove_columns :transactions, :description, :tag_id
    add_reference  :transactions, :transactable, polymorphic: true

    drop_table :transfers
    create_table :transfers do |t|
      t.integer :trasaction_id
      t.integer :other_account_id
      t.timestamps
    end

    create_table :payments do |t|
      t.integer :transaction_id
      t.string :description
      t.integer :tag_id
      t.timestamps
    end
  end

  def down
    add_column :transactions, :description, :string
    add_column :transactions, :tag_id, :integer
    remove_reference :transactions, :transactable, polymorphic: true

    drop_table :transfers
    create_table :transfers do |t|
      t.integer  :to_account_id
      t.integer  :from_account_id
      t.decimal  :amount
      t.date     :transfer_date
    end
    drop_table :payments
  end
end
