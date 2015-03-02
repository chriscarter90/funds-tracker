require 'rails_helper'

describe TransfersController, "GET #index" do
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

      a1 = FactoryGirl.create(:account, user: user)
      a2 = FactoryGirl.create(:account, user: user)

      @t1 = FactoryGirl.create(:transfer, to_account: a1, from_account: a2, transfer_date: "01-08-2014")
      @t2 = FactoryGirl.create(:transfer, to_account: a1, from_account: a2, transfer_date: "03-08-2014")
      @t3 = FactoryGirl.create(:transfer, to_account: a1, from_account: a2, transfer_date: "31-07-2014")

      get :index
    end

    it "assigns their transfers" do
      expect(assigns(:transfers)).to eq [@t2, @t1, @t3]
    end
  end
end
