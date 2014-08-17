class Account < ActiveRecord::Base

  before_save :update_balance

  validates :name, :user, :starting_balance, presence: true
  validates_uniqueness_of :name, scope: :user

  belongs_to :user
  has_many :transactions, dependent: :destroy
  has_many :transfers_out, class_name: "Transfer", source: :from_account, foreign_key: "from_account_id"
  has_many :transfers_in, class_name: "Transfer", source: :to_account, foreign_key: "to_account_id"

  scope :by_name, -> { order(name: :asc) }

  def update_balance
    if valid?
      self.current_balance = self.starting_balance + transactions.sum(:amount)
    end
  end

  def balance_up_to(transaction)
    sum_total = transactions.newest_first.before(transaction).sum(:amount)

    self.starting_balance + sum_total
  end

end
