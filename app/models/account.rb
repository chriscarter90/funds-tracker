class Account < ActiveRecord::Base
  validates :name, :user, :starting_balance, presence: true
  validates_uniqueness_of :name, scope: :user

  belongs_to :user
  has_many :account_transactions, dependent: :destroy
  has_many :payments, through: :account_transactions, source: :transactable, source_type: "Payment", inverse_of: false
  has_many :transfers, through: :account_transactions, source: :transactable, source_type: "Transfer", inverse_of: false
  has_many :other_transfers, class_name: "Transfer", inverse_of: :other_account, foreign_key: :other_account_id

  scope :by_name, -> { order(name: :asc) }
  scope :excluding, ->(account) { where.not(id: account.id) }

  before_save :update_balance

  def update_balance
    if valid?
      self.current_balance = self.starting_balance + account_transactions.sum(:amount)
    end
  end

  def balance_up_to(account_transaction)
    sum_total = account_transactions.newest_first.before(account_transaction).sum(:amount)

    self.starting_balance + sum_total
  end
end
