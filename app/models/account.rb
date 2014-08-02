class Account < ActiveRecord::Base

  before_save :update_balance

  validates :name, :user, :starting_balance, presence: true
  validates_uniqueness_of :name, scope: :user

  belongs_to :user
  has_many :transactions, dependent: :destroy

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
