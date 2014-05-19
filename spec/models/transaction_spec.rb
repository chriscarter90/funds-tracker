require 'spec_helper'

describe Transaction, "validations" do
  it { should validate_presence_of :description }
  it { should validate_presence_of :amount }
  it { should validate_presence_of :account }
end

describe Transaction, "relationships" do
  it { should belong_to :account }
end

describe Transaction, "scopes" do
  describe ".oldest_first" do
    it "should return them with the oldest transaction first" do
      @t1 = FactoryGirl.create(:transaction, created_at: 4.minutes.ago)
      @t2 = FactoryGirl.create(:transaction, created_at: 2.minutes.ago)
      @t3 = FactoryGirl.create(:transaction, created_at: 6.minutes.ago)

      expect(Transaction.oldest_first).to eq [@t3, @t1, @t2]
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
