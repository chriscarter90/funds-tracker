require 'rails_helper'

describe TransfersController, "GET #new" do
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

    it "assigns a new transfer" do
      expect(assigns(:transfer)).to be_a_new Transfer
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

describe TransfersController, "POST #create" do
  context "As a non-logged in user" do
    before do
      account = FactoryGirl.create(:account)

      post :create, account_id: account, transfer: {}
    end

    it "redirects to the login page" do
      expect(response).to redirect_to new_user_session_path
    end
  end

  context "As an authorised user" do
    before do
      @user = FactoryGirl.create(:user)

      @account = FactoryGirl.create(:account, user: @user)

      sign_in @user
    end

    context "with valid params" do
      before do
        other_account = FactoryGirl.create(:account, user: @user)

        valid_params = {
          other_account_id: other_account.id,
          account_transaction_attributes: {
            amount: "500",
            transaction_date: "13-04-2015"
          }
        }

        post :create, account_id: @account, transfer: valid_params
      end

      it "creates a new transfer for the account" do
        expect(@account.transfers.count).to eq 1
        expect(@account.transfers.last.transaction_date).to eq Date.parse("13-04-2015")
      end

      it "should redirect to the transaction list" do
        expect(response).to redirect_to account_account_transactions_path(@account)
      end

      it "should set flash" do
        expect(flash[:success]).to eq "Transfer successfully created."
      end
    end

    context "with invalid params" do
      before do
        invalid_params = {
          other_account_id: nil,
          account_transaction_attributes: {
            amount: "500",
            transaction_date: "13-04-2015"
          }
        }

        post :create, account_id: @account, transfer: invalid_params
      end

      it "doesn't create a transfer" do
        expect(@account.transfers.count).to eq 0
      end

      it "should render new" do
        expect(response).to render_template :new
      end

      it "should set flash" do
        expect(flash[:error]).to eq "Transfer not created."
      end
    end
  end

  context "As an unauthorised user" do
    before do
      user = FactoryGirl.create(:user)

      sign_in user

      @account = FactoryGirl.create(:account)

      post :create, account_id: @account, transfer: {}
    end

    it "redirects to accounts page" do
      expect(response).to redirect_to accounts_path
    end

    it "sets flash" do
      expect(flash[:error]).to eq "Account could not be found."
    end
  end
end

describe TransfersController, "GET #edit" do
  context "As a non-logged in user" do
    before do
      account = FactoryGirl.create(:account)
      transfer = FactoryGirl.create(:transfer, account_transaction: FactoryGirl.create(:account_transaction, account: account))

      get :edit, account_id: account, id: transfer
    end

    it "redirects to the login page" do
      expect(response).to redirect_to new_user_session_path
    end
  end

  context "As an authorised user" do
    before do
      @user = FactoryGirl.create(:user)

      @account = FactoryGirl.create(:account, user: @user)
      @transfer = FactoryGirl.create(:transfer, account_transaction: FactoryGirl.create(:account_transaction, account: @account))

      sign_in @user

      get :edit, account_id: @account, id: @transfer
    end

    it "should assign the account" do
      expect(assigns(:account)).to eq @account
    end

    it "should assign the transfer" do
      expect(assigns(:transfer)).to eq @transfer
    end

    it "should render the edit template" do
      expect(response).to render_template :edit
    end
  end

  context "As an unauthorised user" do
    before do
      user = FactoryGirl.create(:user)

      account = FactoryGirl.create(:account)
      transfer = FactoryGirl.create(:transfer, account_transaction: FactoryGirl.create(:account_transaction, account: account))

      sign_in user

      get :edit, account_id: account, id: transfer
    end

    it "redirects to the index" do
      expect(response).to redirect_to accounts_path
    end

    it "sets flash" do
      expect(flash[:error]).to eq "Account could not be found."
    end
  end
end

describe TransfersController, "PATCH #update" do
  context "As a non-logged in user" do
    before do
      account = FactoryGirl.create(:account)
      transfer = FactoryGirl.create(:transfer, account_transaction: FactoryGirl.create(:account_transaction, account: account))

      patch :update, account_id: account, id: transfer, transfer: { other_account_id: 1 }
    end

    it "redirects to the login page" do
      expect(response).to redirect_to new_user_session_path
    end
  end

  context "As an authorised user" do
    before do
      @user = FactoryGirl.create(:user)

      @account = FactoryGirl.create(:account, user: @user)
      @other_account = FactoryGirl.create(:account, user: @user)
      @transfer = FactoryGirl.create(:transfer, other_account_id: @other_account.id,
                                     account_transaction: FactoryGirl.create(:account_transaction, amount: 20, account: @account))

      sign_in @user
    end

    context "with valid params" do
      before do
        @yet_another_account = FactoryGirl.create(:account, user: @user)

        patch :update, account_id: @account, id: @transfer, transfer: { other_account_id: @yet_another_account.id,
                                                                       account_transaction_attributes: {
                                                                         amount: 50 } }
      end

      it "updates the transfer" do
        expect(@transfer.reload.other_account).to eq @yet_another_account
        expect(@transfer.account_transaction.reload.amount).to eq 50
      end

      it "should redirect to index" do
        expect(response).to redirect_to account_account_transactions_path(@account)
      end

      it "should set flash" do
        expect(flash[:success]).to eq "Transfer successfully updated."
      end
    end

    context "with invalid params" do
      before do
        patch :update, account_id: @account, id: @transfer, transfer: { other_account_id: nil,
                                                                       account_transaction_attributes: {
                                                                         amount: 50 } }
      end

      it "doesn't update transfer" do
        expect(@transfer.reload.other_account).to eq @other_account
        expect(@transfer.account_transaction.reload.amount).to eq 20
      end

      it "should render edit" do
        expect(response).to render_template :edit
      end

      it "should set flash" do
        expect(flash[:error]).to eq "Transfer not updated."
      end
    end

    context "As a unauthorised user" do
      before do
        @user = FactoryGirl.create(:user)

        @account = FactoryGirl.create(:account)
        @other_account = FactoryGirl.create(:account)
        @transfer = FactoryGirl.create(:transfer, other_account_id: @other_account.id,
                                       account_transaction: FactoryGirl.create(:account_transaction, account: @account))

        patch :update, account_id: @account, id: @transfer, transfer: { other_account_id: 4 }
      end

      it "doesn't update transfer" do
        expect(@transfer.reload.other_account).to eq @other_account
      end

      it "should redirect to index" do
        expect(response).to redirect_to accounts_path
      end

      it "should set flash" do
        expect(flash[:error]).to eq "Account could not be found."
      end
    end
  end
end

describe TransfersController, "DELETE #destroy" do
  context "As a non-logged in user" do
    before do
      account = FactoryGirl.create(:account)
      transfer = FactoryGirl.create(:transfer, account_transaction: FactoryGirl.create(:account_transaction, account: account))

      delete :destroy, account_id: account, id: transfer
    end

    it "redirects to the login page" do
      expect(response).to redirect_to new_user_session_path
    end
  end

  context "As an authorised user" do
    before do
      user = FactoryGirl.create(:user)

      @account = FactoryGirl.create(:account, user: user)
      transfer = FactoryGirl.create(:transfer, account_transaction: FactoryGirl.create(:account_transaction, account: @account))

      sign_in user

      delete :destroy, account_id: @account, id: transfer
    end

    it "deletes the transfer" do
      expect(@account.transfers.count).to eq 0
      expect(@account.transfers.last).to be_nil
    end

    it "redirects back to transactions" do
      expect(response).to redirect_to account_account_transactions_path(@account)
    end

    it "sets flash" do
      expect(flash[:success]).to eq "Transfer successfully deleted."
    end
  end

  context "As an unauthorised user" do
    before do
      user = FactoryGirl.create(:user)

      @account = FactoryGirl.create(:account)
      @transfer = FactoryGirl.create(:transfer, account_transaction: FactoryGirl.create(:account_transaction, account: @account))

      sign_in user

      delete :destroy, account_id: @account, id: @transfer
    end

    it "should not delete the transfer" do
      expect(@account.transfers.count).to eq 1
      expect(@account.transfers.last).to eq @transfer
    end

    it "should redirect back to the accounts page" do
      expect(response).to redirect_to(accounts_path)
    end

    it "should set flash" do
      expect(flash[:error]).to eq "Account could not be found."
    end
  end
end
