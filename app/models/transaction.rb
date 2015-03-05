class Transaction < ActiveRecord::Base

  after_save :update_account_balance
  after_destroy :update_account_balance

  validates :description, :amount, :account, :transaction_date, presence: true
  validate :transaction_date_cannot_be_in_the_future

  belongs_to :account
  belongs_to :tag

  scope :newest_first, -> { order(transaction_date: :desc, id: :desc) }
  scope :before, ->(t) { where("transaction_date < ? OR transaction_date = ? AND id < ?", t.transaction_date, t.transaction_date, t.id) }
  scope :tagged_with, ->(tag) { where(tag_id: tag)  }

  def the_date
    transaction_date
  end

  def calculate_amount(account)
    amount
  end

  def update_account_balance
    account.update_balance
    account.save
  end

  def transaction_date_cannot_be_in_the_future
    if transaction_date.present? && transaction_date > Date.today
      errors.add(:transaction_date, "can't be in the future")
    end
  end

end
