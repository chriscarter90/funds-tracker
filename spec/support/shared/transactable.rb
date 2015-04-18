require 'rails_helper'

shared_examples "a transactable object" do
  it { should have_one(:account_transaction).dependent(:destroy) }
  it { should have_one(:account).through(:account_transaction) }

  it { should delegate_method(:amount).to(:account_transaction) }
  it { should delegate_method(:transaction_date).to(:account_transaction) }
end
