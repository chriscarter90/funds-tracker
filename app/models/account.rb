class Account < ActiveRecord::Base

  before_save :update_balance

  validates :name, :user, :starting_balance, presence: true
  validates_uniqueness_of :name, scope: :user

  belongs_to :user
  has_many :transactions

  def update_balance
    if valid?
      self.current_balance = self.starting_balance + transactions.sum(:amount)
    end
  end

end
