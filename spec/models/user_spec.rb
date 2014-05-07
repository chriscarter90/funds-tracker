require 'spec_helper'

describe User, 'validations' do
  it { should validate_presence_of :email }
end

describe User, 'relationships' do
  it { should have_many :accounts }
end
