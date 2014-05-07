class Account < ActiveRecord::Base

  validates :name, :user, presence: true

  belongs_to :user
  has_many :transactions

end
