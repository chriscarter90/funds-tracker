class Transfer < ActiveRecord::Base

  validates :to_account, :from_account, :amount, :transfer_date, presence: true
  validate :transfer_date_cannot_be_in_the_future
  validate :different_accounts

  belongs_to :to_account, class_name: "Account"
  belongs_to :from_account, class_name: "Account"
  has_one :user, through: :from_account

  scope :newest_first, -> { order(transfer_date: :desc) }

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
