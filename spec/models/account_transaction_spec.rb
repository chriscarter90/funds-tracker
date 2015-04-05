require 'rails_helper'

describe AccountTransaction, "validations" do
  it { should validate_presence_of :amount }
  it { should validate_presence_of :account }
  it { should validate_presence_of :transaction_date }
  it { should_not allow_value(2.days.from_now).for(:transaction_date) }
  it { should_not allow_value(2.weeks.from_now).for(:transaction_date) }
  it { should allow_value(Date.today).for(:transaction_date) }
  it { should allow_value(2.days.ago).for(:transaction_date) }
  it { should allow_value(2.weeks.ago).for(:transaction_date) }
end

describe AccountTransaction, "relationships" do
  it { should belong_to :account }
  it { should belong_to :transactable }
end

describe AccountTransaction, "delegations" do
  it { should delegate_method(:description).to(:transactable) }
end

describe AccountTransaction, "scopes" do
  describe ".newest_first" do
    it "should return them with the newest transaction first" do
      t1 = FactoryGirl.create(:account_transaction, transaction_date: 4.days.ago)
      t2 = FactoryGirl.create(:account_transaction, transaction_date: 2.days.ago)
      t3 = FactoryGirl.create(:account_transaction, transaction_date: 6.days.ago)

      expect(AccountTransaction.newest_first).to eq [t2, t1, t3]
    end

    it "should return them with the highest ID first if sharing a date" do
      t1 = FactoryGirl.create(:account_transaction, transaction_date: 4.days.ago, id: 64)
      t2 = FactoryGirl.create(:account_transaction, transaction_date: 4.days.ago, id: 67)
      t3 = FactoryGirl.create(:account_transaction, transaction_date: 4.days.ago, id: 54)
      t4 = FactoryGirl.create(:account_transaction, transaction_date: 3.days.ago)

      expect(AccountTransaction.newest_first).to eq [t4, t2, t1, t3]
    end
  end

  describe ".before" do
    it "should return transactions with a date before the given one" do
      t = FactoryGirl.create(:account_transaction, transaction_date: 3.days.ago)

      t1 = FactoryGirl.create(:account_transaction, transaction_date: 1.days.ago)
      t2 = FactoryGirl.create(:account_transaction, transaction_date: 5.days.ago)
      t3 = FactoryGirl.create(:account_transaction, transaction_date: 2.days.ago)
      t4 = FactoryGirl.create(:account_transaction, transaction_date: 4.days.ago)

      expect(AccountTransaction.before(t)).to match_array [t4, t2]
    end

    it "should also return those with a lower ID if the dates match" do
      t = FactoryGirl.create(:account_transaction, transaction_date: 3.days.ago, id: 55)

      t1 = FactoryGirl.create(:account_transaction, transaction_date: 3.days.ago, id: 56)
      t2 = FactoryGirl.create(:account_transaction, transaction_date: 3.days.ago, id: 54) # Lower ID
      t3 = FactoryGirl.create(:account_transaction, transaction_date: 1.days.ago)
      t4 = FactoryGirl.create(:account_transaction, transaction_date: 5.days.ago)         # Older

      expect(AccountTransaction.before(t)).to match_array [t4, t2]
    end
  end
end

describe AccountTransaction, "callbacks" do
  describe 'after save' do
    it 'should update the current balance of the parent account' do
      account = FactoryGirl.create(:account, starting_balance: 100)

      expect(account.current_balance).to eq 100

      account.account_transactions << FactoryGirl.create(:account_transaction, amount: 50)

      expect(account.reload.current_balance).to eq 150
    end
  end

  describe 'after destroy' do
    it 'should upadte the current balance of the parent account' do
      account = FactoryGirl.create(:account, starting_balance: 100)
      transaction = FactoryGirl.create(:account_transaction, amount: 50)

      account.account_transactions << transaction

      expect(account.reload.current_balance).to eq 150

      transaction.destroy

      expect(account.reload.current_balance).to eq 100
    end
  end
end
