require 'spec_helper'

describe Transaction, "validations" do
  it { should validate_presence_of :description }
  it { should validate_presence_of :amount }
  it { should validate_presence_of :account }
end

describe Transaction, "relationships" do
  it { should belong_to :account }
end
