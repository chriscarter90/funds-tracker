class Transaction < ActiveRecord::Base

  validates :description, :amount, :account, presence: true

  belongs_to :account

end
