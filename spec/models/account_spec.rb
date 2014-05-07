require 'spec_helper'

describe Account, 'validations' do
  it { should validate_presence_of :name }
  it { should validate_presence_of :user }
end

describe Account, 'relationships' do
  it { should belong_to :user }
  it { should have_many :transactions }
end
