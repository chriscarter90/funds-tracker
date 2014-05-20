class AddTagIdToTransaction < ActiveRecord::Migration
  def change
    add_reference :transactions, :tag, index: true
  end
end
