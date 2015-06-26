class RemoveTags < ActiveRecord::Migration
  def change
    remove_column :payments, :tag_id, :integer
    drop_table :tags do |t|
      t.string :name
      t.integer :user_id
    end
  end
end
