require 'rails_helper'

shared_examples "a transactable object" do
  it { should have_one(:account_transaction) }
end
