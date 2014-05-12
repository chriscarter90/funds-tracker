require 'spec_helper'

describe Account, 'validations' do
  it { should validate_presence_of :name }
  it { should validate_presence_of :user }
  it { should validate_presence_of :starting_balance }
  it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
end

describe Account, 'relationships' do
  it { should belong_to :user }
  it { should have_many :transactions }
end
