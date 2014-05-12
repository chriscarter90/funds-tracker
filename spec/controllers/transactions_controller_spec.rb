require 'spec_helper'

describe TransactionsController, "GET #new" do
  context "As a non-logged in user" do
    before do
      account = FactoryGirl.create(:account)

      get :new, account_id: account
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
      expect(flash[:error]).to eq "Account could not be found."
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
        expect(flash[:success]).to eq "Transaction successfully created."
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
        expect(flash[:error]).to eq "Transaction not created."
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
      expect(flash[:error]).to eq "Account could not be found."
    end
  end
end

describe TransactionsController, "GET #edit" do
  context "As a non-logged in user" do
    before do
      account = FactoryGirl.create(:account)
      transaction = FactoryGirl.create(:transaction, account: account)

      get :edit, account_id: account, id: transaction
    end

    it "redirects to the login page" do
      expect(response).to redirect_to new_user_session_path
    end
  end

  context "As an authorised user" do
    before do
      user = FactoryGirl.create(:user)

      @account = FactoryGirl.create(:account, user: user)
      @transaction = FactoryGirl.create(:transaction, account: @account)

      sign_in user

      get :edit, account_id: @account, id: @transaction
    end

    it "should assign the account" do
      expect(assigns(:account)).to eq @account
    end

    it "should assign the transaction" do
      expect(assigns(:transaction)).to eq @transaction
    end

    it "should render edit" do
      expect(response).to render_template :edit
    end
  end

  context "As an unauthorised user" do
    before do
      user = FactoryGirl.create(:user)

      account = FactoryGirl.create(:account)
      transaction = FactoryGirl.create(:transaction, account: account)

      sign_in user

      get :edit, account_id: account, id: transaction
    end

    it "should redirect back to accounts" do
      expect(response).to redirect_to accounts_path
    end

    it "should set flash" do
      expect(flash[:error]).to eq "Account could not be found."
    end
  end
end

describe TransactionsController, "PATCH #update" do
  context "As a non-logged in user" do
    before do
      account = FactoryGirl.create(:account)
      transaction = FactoryGirl.create(:transaction, account: account)

      patch :update, account_id: account, id: transaction, transaction: { description: "New Description" }
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

    context "updating a transaction on their account" do
      before do
        @account = FactoryGirl.create(:account, user: @user)
        @transaction = FactoryGirl.create(:transaction, description: "A Transaction", amount: 12, account: @account)
      end

      context "with valid params" do
        before do
          patch :update, account_id: @account, id: @transaction, transaction: { description: "Updated Transaction", amount: 20 }
        end

        it "updates the transaction" do
          expect(@transaction.reload.description).to eq "Updated Transaction"
          expect(@transaction.reload.amount).to eq 20
        end

        it "should redirect back to the account" do
          expect(response).to redirect_to account_path(@account)
        end

        it "should set flash" do
          expect(flash[:success]).to eq "Transaction successfully updated."
        end
      end

      context "with invalid params" do
        before do
          patch :update, account_id: @account, id: @transaction, transaction: { description: "", amount: 45 }
        end

        it "doesn't update the transaction" do
          expect(@transaction.reload.description).to eq "A Transaction"
          expect(@transaction.reload.amount).to eq 12
        end

        it "should render edit" do
          expect(response).to render_template :edit
        end

        it "should set flash" do
          expect(flash[:error]).to eq "Transaction not updated."
        end
      end
    end

    context "updating someone elses transaction" do
      before do
        @account = FactoryGirl.create(:account, name: "Someone elses account")
        @transaction = FactoryGirl.create(:transaction, description: "Someone elses transaction", amount: 12, account: @account)

        patch :update, account_id: @account, id: @transaction, transaction: { description: "Mine now" }
      end

      it "doesn't update the transaction" do
        expect(@transaction.reload.description).to eq "Someone elses transaction"
      end

      it "redirects to the account list" do
        expect(response).to redirect_to accounts_path
      end

      it "sets flash" do
        expect(flash[:error]).to eq "Account could not be found."
      end
    end
  end
end
