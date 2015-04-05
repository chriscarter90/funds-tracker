class Payment < ActiveRecord::Base
  include Transactable

  belongs_to :tag
  validates :description, :account_transaction, presence: true

  scope :tagged_with, ->(tag) { where(tag_id: tag)  }

  accepts_nested_attributes_for :account_transaction

end
