require 'spec_helper'

describe HomeController, "GET #show" do
  before do
    get :show
  end

  it "should be successful" do
    expect(response).to be_success
  end

  it "should render the index" do
    expect(response).to render_template :show
  end
end
