class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :last_name, presence: true

  has_many :accounts, dependent: :destroy
  has_many :transactions, through: :accounts, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :transfers, through: :accounts, source: :transfers_in
end
