class Transaction < ActiveRecord::Base

  after_save :update_account_balance
  after_destroy :update_account_balance

  validates :description, :amount, :account, presence: true

  belongs_to :account

  scope :oldest_first, -> { order(:created_at) }

  def update_account_balance
    account.update_balance
    account.save
  end

end
