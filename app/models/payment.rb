class Payment < ActiveRecord::Base
  include Transactable

  validates :description, :account_transaction, presence: true

  scope :newest_first, -> { joins(:account_transaction).order("account_transactions.transaction_date DESC", id: :desc) }

  accepts_nested_attributes_for :account_transaction, update_only: true

end
