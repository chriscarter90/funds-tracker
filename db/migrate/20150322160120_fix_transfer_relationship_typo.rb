class FixTransferRelationshipTypo < ActiveRecord::Migration
  def change
    rename_column :transfers, :trasaction_id, :transaction_id
  end
end
