require 'spec_helper'

describe TagsController, "GET #index" do
  context "As a non-logged in user" do
    before do
      get :index
    end

    it "redirects to the login page" do
      expect(response).to redirect_to new_user_session_path
    end
  end

  context "As a logged in user" do
    before do
      user = FactoryGirl.create(:user)
      sign_in user

      user.tags = FactoryGirl.create_list(:tag, 6)

      get :index
    end

    it "assigns their tags" do
      expect(assigns(:tags).size).to eq 6
    end
  end
end
