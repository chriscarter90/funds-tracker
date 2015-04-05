require 'rails_helper'

describe User, 'validations' do
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email }
end

describe User, 'relationships' do
  it { should have_many(:accounts).dependent(:destroy) }
  it { should have_many(:account_transactions).through(:accounts).dependent(:destroy) }
  it { should have_many(:payments).through(:account_transactions).source(:transactable) }
  it { should have_many(:transfers).through(:account_transactions).source(:transactable) }
  it { should have_many(:tags).dependent(:destroy) }
end
