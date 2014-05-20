class Tag < ActiveRecord::Base

  validates :name, :user, presence: true

  has_many :transactions, dependent: :nullify
  belongs_to :user

end
