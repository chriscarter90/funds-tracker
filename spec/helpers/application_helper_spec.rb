require 'rails_helper'

describe ApplicationHelper, "#bootstrap_class_for" do
  it "returns the correct mappings" do
    expect(helper.bootstrap_class_for("success")).to eq "alert-success"
    expect(helper.bootstrap_class_for("error")).to   eq "alert-danger"
    expect(helper.bootstrap_class_for("alert")).to   eq "alert-warning"
    expect(helper.bootstrap_class_for("notice")).to  eq "alert-info"
  end

  it "returns the correct message with symbols" do
    expect(helper.bootstrap_class_for(:success)).to eq "alert-success"
    expect(helper.bootstrap_class_for(:error)).to   eq "alert-danger"
    expect(helper.bootstrap_class_for(:alert)).to   eq "alert-warning"
    expect(helper.bootstrap_class_for(:notice)).to  eq "alert-info"
  end

  it "returns the empty with an unknown value" do
    expect(helper.bootstrap_class_for(:testing)).to eq ""
    expect(helper.bootstrap_class_for("testing")).to eq ""
    expect(helper.bootstrap_class_for(123)).to eq ""
  end
end
