require 'spec_helper'

describe Transaction, "validations" do
  it { should validate_presence_of :description }
  it { should validate_presence_of :amount }
  it { should validate_presence_of :account }
  it { should validate_presence_of :transaction_date }
  it { should_not allow_value(2.days.from_now).for(:transaction_date) }
  it { should_not allow_value(2.weeks.from_now).for(:transaction_date) }
  it { should allow_value(Date.today).for(:transaction_date) }
  it { should allow_value(2.days.ago).for(:transaction_date) }
  it { should allow_value(2.weeks.ago).for(:transaction_date) }
end

describe Transaction, "relationships" do
  it { should belong_to :account }
end

describe Transaction, "scopes" do
  describe ".newest_first" do
    it "should return them with the newest transaction first" do
      @t1 = FactoryGirl.create(:transaction, transaction_date: 4.days.ago)
      @t2 = FactoryGirl.create(:transaction, transaction_date: 2.days.ago)
      @t3 = FactoryGirl.create(:transaction, transaction_date: 6.days.ago)

      expect(Transaction.newest_first).to eq [@t2, @t1, @t3]
    end
  end
end

describe Transaction, "callbacks" do
  describe 'after save' do
    it 'should update the current balance of the parent account' do
      account = FactoryGirl.create(:account, starting_balance: 100)

      expect(account.current_balance).to eq 100

      account.transactions << FactoryGirl.create(:transaction, amount: 50)

      expect(account.reload.current_balance).to eq 150
    end
  end

  describe 'after destroy' do
    it 'should upadte the current balance of the parent account' do
      account = FactoryGirl.create(:account, starting_balance: 100)
      transaction = FactoryGirl.create(:transaction, amount: 50)

      account.transactions << transaction

      expect(account.reload.current_balance).to eq 150

      transaction.destroy

      expect(account.reload.current_balance).to eq 100
    end
  end
end
