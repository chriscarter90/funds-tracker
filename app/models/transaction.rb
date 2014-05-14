class Transaction < ActiveRecord::Base

  validates :description, :amount, :account, presence: true

  belongs_to :account

  scope :oldest_first, -> { order(:created_at) }

end
