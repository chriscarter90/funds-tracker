module Transactable
  extend ActiveSupport::Concern

  included do
    has_one :account_transaction, as: :transactable
    has_one :account, through: :account_transaction

    delegate :amount, :transaction_date, to: :account_transaction
  end

end
