class Tag < ActiveRecord::Base

  validates :name, presence: true

  has_many :transactions

end
