require 'rails_helper'

describe Payment, "includes" do
  it_behaves_like "a transactable object"
end

describe Payment, "validations" do
  it { should validate_presence_of :description }
  it { should validate_presence_of :account_transaction }
  it { should accept_nested_attributes_for :account_transaction }
end

describe Payment, "relationships" do
  it { should belong_to :tag }
end

describe Payment, "scopes" do
  describe ".tagged_with" do
    it "should return only those transactions tagged wiht the specified tag" do
      @tag_1 = FactoryGirl.create(:tag)
      @tag_2 = FactoryGirl.create(:tag)

      @p1 = FactoryGirl.create(:payment, tag: @tag_1)
      @p2 = FactoryGirl.create(:payment, tag: @tag_2)
      @p3 = FactoryGirl.create(:payment, tag: @tag_2)
      @p4 = FactoryGirl.create(:payment, tag: @tag_1)
      @p5 = FactoryGirl.create(:payment, tag: @tag_1)

      expect(Payment.tagged_with(@tag_1)).to match_array([@p1, @p4, @p5])
      expect(Payment.tagged_with(@tag_2)).to match_array([@p2, @p3])
    end
  end
end
