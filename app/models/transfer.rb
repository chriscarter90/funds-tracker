class Transfer < ActiveRecord::Base
  include Transactable

  validates :other_account, :account_transaction, presence: true

  belongs_to :other_account, class_name: "Account", inverse_of: false

  accepts_nested_attributes_for :account_transaction

  def description
    "Money transferred between ##{account_transaction.account_id} and ##{other_account_id}."
  end
end
