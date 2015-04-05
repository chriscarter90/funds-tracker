class AccountTransaction < ActiveRecord::Base
  validates :amount, :account, :transaction_date, presence: true
  validate :transaction_date_cannot_be_in_the_future

  belongs_to :account
  belongs_to :transactable, polymorphic: true

  delegate :description, to: :transactable

  scope :newest_first, -> { order(transaction_date: :desc, id: :desc) }
  scope :before, ->(t) { where("transaction_date < ? OR transaction_date = ? AND id < ?", t.transaction_date, t.transaction_date, t.id) }

  after_save :update_account_balance
  after_destroy :update_account_balance

  private

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
