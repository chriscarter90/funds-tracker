require 'rails_helper'

describe Transfer, "includes" do
  it_behaves_like "a transactable object"
end

describe Transfer, "validations" do
  it { should validate_presence_of :other_account }
  it { should validate_presence_of :account_transaction }
  it { should accept_nested_attributes_for :account_transaction }
end

describe Transfer, "methods" do
  describe "#description" do
    it "should generate a description based on the source and destination accounts" do
      acc1 = FactoryGirl.create(:account, id: 55)
      acc2 = FactoryGirl.create(:account, id: 123)

      transfer = FactoryGirl.create(:transfer, other_account: acc1,
                                    account_transaction: FactoryGirl.create(:account_transaction, account: acc2)
                                   )

      expect(transfer.description).to eq "Money transferred between #123 and #55."
    end
  end
end
