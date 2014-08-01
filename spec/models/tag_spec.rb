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

describe Tag, 'scopes' do
  describe "by_name" do
    it "should return tags in name order" do
      t1 = FactoryGirl.create(:tag, name: 'g')
      t2 = FactoryGirl.create(:tag, name: 'c')
      t3 = FactoryGirl.create(:tag, name: 'e')

      expect(Tag.by_name).to eq [t2, t3, t1]
    end
  end
end
