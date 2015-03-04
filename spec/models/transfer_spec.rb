require 'rails_helper'

describe Transfer, 'validations' do
  it { should validate_presence_of :to_account }
  it { should validate_presence_of :from_account }
  it { should validate_presence_of :amount }
  it { should validate_presence_of :transfer_date }
  it { should_not allow_value(2.days.from_now).for(:transfer_date) }
  it { should_not allow_value(2.weeks.from_now).for(:transfer_date) }
  it { should allow_value(Date.today).for(:transfer_date) }
  it { should allow_value(2.days.ago).for(:transfer_date) }
  it { should allow_value(2.weeks.ago).for(:transfer_date) }

  context "transferring between the same account" do
    it "should not be valid" do
      account = FactoryGirl.create(:account)

      expect(FactoryGirl.build(:transfer, to_account: account, from_account: account)).not_to be_valid
    end
  end
end

describe Transfer, "relationships" do
  it { should belong_to(:to_account).class_name('Account') }
  it { should belong_to(:from_account).class_name('Account') }
  it { should have_one(:user).through(:from_account) }
end

describe Transfer, "scopes" do
  describe ".newest_first" do
    it "should return them with the newest transfer first" do
      t1 = FactoryGirl.create(:transfer, transfer_date: 4.days.ago)
      t2 = FactoryGirl.create(:transfer, transfer_date: 2.days.ago)
      t3 = FactoryGirl.create(:transfer, transfer_date: 6.days.ago)

      expect(Transfer.newest_first).to eq [t2, t1, t3]
    end
  end
end
