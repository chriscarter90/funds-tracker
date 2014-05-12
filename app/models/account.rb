class Account < ActiveRecord::Base

  validates :name, :user, :starting_balance, presence: true
  validates_uniqueness_of :name, scope: :user

  belongs_to :user
  has_many :transactions

end
