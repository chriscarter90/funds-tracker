require 'spec_helper'

describe Tag, 'validations' do
  it { should validate_presence_of :name }
end

describe Tag, 'relationships' do
  it { should have_many(:transactions).dependent(:nullify) }
end
