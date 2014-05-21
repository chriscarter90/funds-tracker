require 'spec_helper'

describe Tag, 'validations' do
  it { should validate_presence_of :name }
  it { should validate_presence_of :user }
  it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
end

describe Tag, 'relationships' do
  it { should have_many(:transactions).dependent(:nullify) }
  it { should belong_to(:user) }
end
