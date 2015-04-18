class Payment < ActiveRecord::Base
  include Transactable

  belongs_to :tag
  validates :description, :account_transaction, presence: true

  scope :tagged_with, ->(tag) { where(tag_id: tag)  }
  scope :newest_first, -> { joins(:account_transaction).order("account_transactions.transaction_date DESC", id: :desc) }

  accepts_nested_attributes_for :account_transaction, update_only: true

end
