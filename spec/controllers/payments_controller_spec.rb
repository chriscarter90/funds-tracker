require 'rails_helper'

describe PaymentsController, "GET #new" do
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

    it "assigns a new payment" do
      expect(assigns(:payment)).to be_a_new Payment
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

describe PaymentsController, "POST #create" do
  context "As a non-logged in user" do
    before do
      account = FactoryGirl.create(:account)

      post :create, account_id: account, payment: {}
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
        valid_params = {
          description: "A Payment",
          account_transaction_attributes: {
            amount: "500",
            transaction_date: "12-04-2015"
          }
        }

        post :create, account_id: @account, payment: valid_params
      end

      it "creates a new transaction for the account" do
        expect(@account.payments.count).to eq 1
        expect(@account.payments.last.description).to eq "A Payment"
      end

      it "redirects back to the transaction list" do
        expect(response).to redirect_to account_account_transactions_path(@account)
      end

      it "sets flash" do
        expect(flash[:success]).to eq "Payment successfully created."
      end
    end

    context "with invalid params" do
      before do
        invalid_params = {
          description: "",
          account_transaction_attributes: {
            amount: "500",
            transaction_date: "12-04-2015"
          }
        }

        post :create, account_id: @account, payment: invalid_params
      end

      it "doesn't create a payment" do
        expect(@account.payments.count).to eq 0
      end

      it "renders new" do
        expect(response).to render_template :new
      end

      it "sets flash" do
        expect(flash[:error]).to eq "Payment not created."
      end
    end
  end

  context "As an unauthorised user" do
    before do
      user = FactoryGirl.create(:user)

      sign_in user

      @account = FactoryGirl.create(:account)

      post :create, account_id: @account, payment: {}
    end

    it "redirects to accounts page" do
      expect(response).to redirect_to accounts_path
    end

    it "sets flash" do
      expect(flash[:error]).to eq "Account could not be found."
    end
  end
end

describe PaymentsController, "GET #edit" do
  context "As a non-logged in user" do
    before do
      account = FactoryGirl.create(:account)
      payment = FactoryGirl.create(:payment, account_transaction: FactoryGirl.create(:account_transaction, account: account))

      get :edit, account_id: account, id: payment
    end

    it "redirects to the login page" do
      expect(response).to redirect_to new_user_session_path
    end
  end

  context "As an authorised user" do
    before do
      user = FactoryGirl.create(:user)

      @account = FactoryGirl.create(:account, user: user)
      @payment = FactoryGirl.create(:payment, account_transaction: FactoryGirl.create(:account_transaction, account: @account))

      sign_in user

      get :edit, account_id: @account, id: @payment
    end

    it "should assign the account" do
      expect(assigns(:account)).to eq @account
    end

    it "should assign the payment" do
      expect(assigns(:payment)).to eq @payment
    end

    it "should render edit" do
      expect(response).to render_template :edit
    end
  end

  context "As an unauthorised user" do
    before do
      user = FactoryGirl.create(:user)

      account = FactoryGirl.create(:account)
      payment = FactoryGirl.create(:payment, account_transaction: FactoryGirl.create(:account_transaction, account: account))

      sign_in user

      get :edit, account_id: account, id: payment
    end

    it "should redirect back to accounts" do
      expect(response).to redirect_to accounts_path
    end

    it "should set flash" do
      expect(flash[:error]).to eq "Account could not be found."
    end
  end
end

describe PaymentsController, "PATCH #update" do
  context "As a non-logged in user" do
    before do
      account = FactoryGirl.create(:account)
      payment = FactoryGirl.create(:payment, account_transaction: FactoryGirl.create(:account_transaction, account: account))

      patch :update, account_id: account, id: payment, payment: { description: "New Description" }
    end

    it "redirects to the login page" do
      expect(response).to redirect_to new_user_session_path
    end
  end

  context "As an authorised user" do
    before do
      @user = FactoryGirl.create(:user)

      @account = FactoryGirl.create(:account, user: @user)
      @payment = FactoryGirl.create(:payment, description: "A Payment",
                                    account_transaction: FactoryGirl.create(:account_transaction, amount: 12, account: @account))

      sign_in @user
    end

    context "with valid params" do
      before do
        patch :update, account_id: @account, id: @payment, payment: { description: "Updated Payment",
                                                                      account_transaction_attributes: {
                                                                        amount: 20 } }
      end

      it "updates the payment" do
        expect(@payment.reload.description).to eq "Updated Payment"
        expect(@payment.account_transaction.reload.amount).to eq 20
      end

      it "should redirect back to the account" do
        expect(response).to redirect_to account_account_transactions_path(@account)
      end

      it "should set flash" do
        expect(flash[:success]).to eq "Payment successfully updated."
      end
    end

    context "with invalid params" do
      before do
        patch :update, account_id: @account, id: @payment, payment: { description: "",
                                                                      account_transaction_attributes: {
                                                                        amount: 20 } }
      end

      it "doesn't update the payment" do
        expect(@payment.reload.description).to eq "A Payment"
        expect(@payment.account_transaction.reload.amount).to eq 12
      end

      it "should render edit" do
        expect(response).to render_template :edit
      end

      it "should set flash" do
        expect(flash[:error]).to eq "Payment not updated."
      end
    end

    context "As an unauthorised user" do
      before do
        @user = FactoryGirl.create(:user)

        @account = FactoryGirl.create(:account)
        @payment = FactoryGirl.create(:payment, description: "Someone elses payment",
                                      account_transaction: FactoryGirl.create(:account_transaction, account: @account))

        sign_in @user

        patch :update, account_id: @account, id: @payment, payment: { description: "Mine now" }
      end

      it "doesn't update the payment" do
        expect(@payment.reload.description).to eq "Someone elses payment"
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

describe PaymentsController, "DELETE #destroy" do
  context "As a non-logged in user" do
    before do
      account = FactoryGirl.create(:account)
      payment = FactoryGirl.create(:payment, account_transaction: FactoryGirl.create(:account_transaction, account: account))

      delete :destroy, account_id: account, id: payment
    end

    it "redirects to the login page" do
      expect(response).to redirect_to new_user_session_path
    end
  end

  context "As an authorised user" do
    before do
      user = FactoryGirl.create(:user)

      @account = FactoryGirl.create(:account, user: user)
      payment = FactoryGirl.create(:payment, account_transaction: FactoryGirl.create(:account_transaction, account: @account))

      sign_in user

      delete :destroy, account_id: @account, id: payment
    end

    it "deletes the payment" do
      expect(@account.payments.count).to eq 0
      expect(@account.payments.last).to be_nil
    end

    it "redirects back to transactions" do
      expect(response).to redirect_to account_account_transactions_path(@account)
    end

    it "sets flash" do
      expect(flash[:success]).to eq "Payment successfully deleted."
    end
  end

  context "As an unauthorised user" do
    before do
      user = FactoryGirl.create(:user)

      @account = FactoryGirl.create(:account)
      @payment = FactoryGirl.create(:payment, account_transaction: FactoryGirl.create(:account_transaction, account: @account))

      sign_in user

      delete :destroy, account_id: @account, id: @payment
    end

    it "should not delete the payment" do
      expect(@account.payments.count).to eq 1
      expect(@account.payments.last).to eq @payment
    end

    it "should redirect back to the accounts page" do
      expect(response).to redirect_to(accounts_path)
    end

    it "should set flash" do
      expect(flash[:error]).to eq "Account could not be found."
    end
  end
end
