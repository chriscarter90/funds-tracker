require 'rails_helper'

describe Payment, "includes" do
  it_behaves_like "a transactable object"
end

describe Payment, "validations" do
  it { should validate_presence_of :description }
  it { should validate_presence_of :account_transaction }
  it { should accept_nested_attributes_for :account_transaction }
end
