module Transactable
  extend ActiveSupport::Concern

  included do
    has_one :account_transaction, as: :transactable
  end

end
