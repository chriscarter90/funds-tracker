class Tag < ActiveRecord::Base

  validates :name, :user, presence: true
  validates_uniqueness_of :name, scope: :user

  has_many :transactions, dependent: :nullify
  belongs_to :user

  scope :by_name, -> { order(name: :asc) }

end
