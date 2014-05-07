require 'spec_helper'

describe AccountsController, "GET #index" do
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

      user.accounts = FactoryGirl.create_list(:account, 3)

      get :index
    end

    it "assigns their accounts" do
      expect(assigns(:accounts).size).to eq 3
    end
  end
end

describe AccountsController, "GET #new" do
  context "As a non-logged in user" do
    before do
      get :new
    end

    it "redirects to the login page" do
      expect(response).to redirect_to new_user_session_path
    end
  end

  context "As a logged in user" do
    before do
      user = FactoryGirl.create(:user)
      sign_in user

      get :new
    end

    it "assigns a new account" do
      expect(assigns(:account)).to be_a_new Account
    end

    it "renders the new template" do
      expect(response).to render_template :new
    end
  end
end

describe AccountsController, "POST #create" do
  context "As a non-logged in user" do
    before do
      account_attrs = FactoryGirl.attributes_for(:account)

      post :create, account: account_attrs
    end

    it "redirects to the login page" do
      expect(response).to redirect_to new_user_session_path
    end
  end

  context "As a logged in user" do
    before do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    context "with valid params" do
      before do
        valid_params = FactoryGirl.attributes_for(:account, name: "An Example Account")

        post :create, account: valid_params
      end

      it "creates a new account for the user" do
        expect(@user.accounts.count).to eq 1
        expect(@user.accounts.last.name).to eq "An Example Account"
      end

      it "should redirect to index" do
        expect(response).to redirect_to accounts_path
      end

      it "should set flash" do
        expect(flash[:notice]).to eq "Account successfully created."
      end
    end

    context "with invalid params" do
      before do
        invalid_params = FactoryGirl.attributes_for(:account, name: "")

        post :create, account: invalid_params

        it "doesn't create an account" do
          expect(@user.accounts.count).to eq 0
        end

        it "should render new" do
          expect(response).to render_template :new
        end

        it "should set flash" do
          expect(flash[:alert]).to eq "Account not created."
        end
      end
    end
  end
end
