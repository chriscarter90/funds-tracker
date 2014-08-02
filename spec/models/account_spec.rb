require 'spec_helper'

describe Account, 'validations' do
  it { should validate_presence_of :name }
  it { should validate_presence_of :user }
  it { should validate_presence_of :starting_balance }
  it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
end

describe Account, 'relationships' do
  it { should belong_to :user }
  it { should have_many(:transactions).dependent(:destroy) }
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

describe Account, 'scopes' do
  describe 'by_name' do
    it "should return accounts by name" do
      a1 = FactoryGirl.create(:account, name: 'Account B')
      a2 = FactoryGirl.create(:account, name: 'Account C')
      a3 = FactoryGirl.create(:account, name: 'Account A')

      expect(Account.by_name).to eq [a3, a1, a2]
    end
  end
end

describe Account, 'methods' do
  describe 'balance_up_to' do
    it "should only return the starting balance plus all those transactions before the one provided" do
      @account = FactoryGirl.create(:account, starting_balance: 100)

      @t = FactoryGirl.create(:transaction, account: @account, transaction_date: 3.days.ago, amount: 10)

      @account.transactions << [FactoryGirl.create(:transaction, transaction_date: 4.days.ago, amount: 50),
                                FactoryGirl.create(:transaction, transaction_date: 2.days.ago, amount: 20),
                                FactoryGirl.create(:transaction, transaction_date: 5.days.ago, amount: 25)]

      expect(@account.balance_up_to(@t)).to eq 175
    end
  end
end
