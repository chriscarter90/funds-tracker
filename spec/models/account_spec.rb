require 'spec_helper'

describe Account, 'validations' do
  it { should validate_presence_of :name }
  it { should validate_presence_of :user }
  it { should validate_presence_of :starting_balance }
  it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
end

describe Account, 'relationships' do
  it { should belong_to :user }
  it { should have_many :transactions }
end

describe Account, 'callbacks' do
  describe 'after save' do
    it 'should set the current balance' do
      account = FactoryGirl.build(:account, starting_balance: 100, current_balance: nil)

      account.save!
      expect(account.current_balance).to eq 100
    end

    it 'should set the current balance based on the transactions' do
      account = FactoryGirl.create(:account, starting_balance: 100)

      account.transactions << FactoryGirl.create(:transaction, amount: 50)

      account.save!
      expect(account.current_balance).to eq 150
    end
  end
end
