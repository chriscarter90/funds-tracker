class Transfer < ActiveRecord::Base

  validates :to_account, :from_account, :amount, :transfer_date, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validate :transfer_date_cannot_be_in_the_future
  validate :different_accounts

  belongs_to :to_account, class_name: "Account"
  belongs_to :from_account, class_name: "Account"
  has_one :user, through: :from_account

  scope :newest_first, -> { order(transfer_date: :desc) }

  def the_date
    transfer_date
  end

  def calculate_amount(account)
    if account == to_account
      amount
    elsif account == from_account
      -1 * amount
    else
      0
    end
  end

  def display_name(account)
    if account == to_account
      "Transfer in from " + from_account.name
    elsif account == from_account
      "Transfer out to " + to_account.name
    else
      ""
    end
  end

  private
  def transfer_date_cannot_be_in_the_future
    if transfer_date.present? && transfer_date > Date.today
      errors.add(:transfer_date, "can't be in the future")
    end
  end

  def different_accounts
    if to_account_id == from_account_id
      errors.add(:to_account, "can't be between the same as the from account")
    end
  end
end
