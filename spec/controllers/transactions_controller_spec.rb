require 'spec_helper'

describe TransactionsController, "GET #new" do
  context "As a non-logged in user" do
    before do
      @account = FactoryGirl.create(:account)

      get :new, account_id: @account
    end

    it "redirects to the login page" do
      expect(response).to redirect_to new_user_session_path
    end
  end

  context "As an authorised user" do
    before do
      user = FactoryGirl.create(:user)

      @account = FactoryGirl.create(:account, user: user)

      sign_in user

      get :new, account_id: @account
    end

    it "assigns the account" do
      expect(assigns(:account)).to eq @account
    end

    it "assigns a new transaction" do
      expect(assigns(:transaction)).to be_a_new Transaction
    end

    it "renders the new template" do
      expect(response).to render_template :new
    end
  end

  context "As an unauthorised user" do
    before do
      user = FactoryGirl.create(:user)

      @account = FactoryGirl.create(:account)

      sign_in user

      get :new, account_id: @account
    end

    it "redirects to the accounts page" do
      expect(response).to redirect_to accounts_path
    end

    it "sets flash" do
      expect(flash[:alert]).to eq "Account could not be found."
    end
  end
end

describe TransactionsController, "POST #create" do
  context "As a non-logged in user" do
    before do
      @account = FactoryGirl.create(:account)

      valid_params = FactoryGirl.attributes_for(:transaction)

      post :create, account_id: @account, transaction: valid_params
    end

    it "should redirect to the login page" do
      expect(response).to redirect_to new_user_session_path
    end
  end

  context "As an authorised user" do
    before do
      user = FactoryGirl.create(:user)

      @account = FactoryGirl.create(:account, user: user)

      sign_in user
    end

    context "with valid params" do
      before do
        valid_params = FactoryGirl.attributes_for(:transaction, description: "A Transaction")

        post :create, account_id: @account, transaction: valid_params
      end

      it "creates a new transaction for the account" do
        expect(@account.transactions.count).to eq 1
        expect(@account.transactions.last.description).to eq "A Transaction"
      end

      it "redirects back to the transaction list" do
        expect(response).to redirect_to account_path(@account)
      end

      it "sets flash" do
        expect(flash[:notice]).to eq "Transaction successfully created."
      end
    end

    context "with invalid params" do
      before do
        invalid_params = FactoryGirl.attributes_for(:transaction, description: "")

        post :create, account_id: @account, transaction: invalid_params
      end

      it "doesn't create a transaction" do
        expect(@account.transactions.count).to eq 0
      end

      it "renders new" do
        expect(response).to render_template :new
      end

      it "sets flash" do
        expect(flash[:alert]).to eq "Transaction not created."
      end
    end
  end

  context "As an unauthorised user" do
    before do
      user = FactoryGirl.create(:user)

      sign_in user

      @account = FactoryGirl.create(:account)

      valid_params = FactoryGirl.attributes_for(:transaction)

      post :create, account_id: @account, transaction: valid_params
    end

    it "redirects to accounts page" do
      expect(response).to redirect_to accounts_path
    end

    it "sets flash" do
      expect(flash[:alert]).to eq "Account could not be found."
    end
  end
end
