require 'rails_helper'

describe TagsHelper, ".tag_with_link" do
  it "should return a link with a span" do
    tag = FactoryGirl.create(:tag, name: "A tag")

    expect(helper.tag_with_link(tag, '/a_link_target')).to eq \
      '<a class="tag" href="/a_link_target"><span class="label label-info">A tag</span></a>'
  end
end

describe TagsHelper, ".tag_without_link" do
  it "should return a span" do
    tag = FactoryGirl.create(:tag, name: "Another tag")

    expect(helper.tag_without_link(tag)).to eq \
      '<span class="label label-info">Another tag</span>'
  end
end
