class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :last_name, :email, presence: true

  has_many :accounts, dependent: :destroy
  has_many :account_transactions, through: :accounts, dependent: :destroy
  has_many :payments, through: :account_transactions, source: :transactable, source_type: "Payment", inverse_of: false
  has_many :transfers, through: :account_transactions, source: :transactable, source_type: "Transfer", inverse_of: false
end
