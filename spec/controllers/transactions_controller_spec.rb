require 'spec_helper'

describe TransactionsController, "GET #index" do
  context "As a non-logged in user" do
    before do
      account = FactoryGirl.create(:account)

      get :index, account_id: account
    end

    it "redirects to the login page" do
      expect(response).to redirect_to new_user_session_path
    end
  end

  context "As a logged in user" do
    before do
      @user = FactoryGirl.create(:user)
      sign_in @user

      @account = FactoryGirl.create(:account, user: @user)
    end

    context "with less than a page" do
      before do
        @tag_1 = FactoryGirl.create(:tag, user: @user)
        @tag_2 = FactoryGirl.create(:tag, user: @user)

        @account.transactions << [FactoryGirl.create(:transaction, description: "Transaction #1", transaction_date: 5.days.ago, tag: @tag_1),
                                  FactoryGirl.create(:transaction, description: "Transaction #3", transaction_date: 5.weeks.ago, tag: @tag_2),
                                  FactoryGirl.create(:transaction, description: "Transaction #2", transaction_date: 3.days.ago, tag: @tag_1)]

        get :index, account_id: @account
      end

      it "assigns the account" do
        expect(assigns(:account)).to eq @account
      end

      it "assigns the transactions" do
        expect(assigns(:transactions).size).to eq 3
        expect(assigns(:transactions).map(&:description)).to eq ["Transaction #2", "Transaction #1", "Transaction #3"]
      end

      it "assigns the tags" do
        expect(assigns(:tags)).to match_array [@tag_1, @tag_2]
      end

      it "renders index" do
        expect(response).to render_template :index
      end
    end

    context "with more than a page" do
      before do
        @account.update_attributes(starting_balance: 100)

        1.upto(15) do |i|
          @account.transactions << FactoryGirl.create(:transaction, description: "Transaction ##{i}", transaction_date: i.days.ago, amount: 10)
        end
      end

      it "should grab the first 10 transactions on page 1" do
        get :index, account_id: @account, page: 1

        expect(assigns(:transactions).size).to eq 10
        expect(assigns(:transactions).map(&:description)).to include("Transaction #1", "Transaction #10")
        expect(assigns(:transactions).map(&:description)).to_not include("Transaction #11", "Transaction #15")
      end

      it "should set the running total to the starting balance on page 1" do
        get :index, account_id: @account, page: 1

        expect(assigns(:running_total)).to eq 100
      end

      it "should grab the last 5 transactions on page 2" do
        get :index, account_id: @account, page: 2

        expect(assigns(:transactions).size).to eq 5
        expect(assigns(:transactions).map(&:description)).to_not include("Transaction #1", "Transaction #10")
        expect(assigns(:transactions).map(&:description)).to include("Transaction #11", "Transaction #15")
      end

      it "should set the running total on page 2" do
        get :index, account_id: @account, page: 2

        expect(assigns(:running_total)).to eq 200
      end
    end
  end
end

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
        expect(response).to redirect_to account_transactions_path(@account)
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
          expect(response).to redirect_to account_transactions_path(@account)
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

describe TransactionsController, "DELETE #destroy" do
  context "As a non-logged in user" do
    before do
      account = FactoryGirl.create(:account)
      transaction = FactoryGirl.create(:transaction, account: account)

      delete :destroy, account_id: account, id: transaction
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

    context "deleting a transaction on their account" do
      before do
        @account = FactoryGirl.create(:account, user: @user)
        transaction = FactoryGirl.create(:transaction, account: @account)

        delete :destroy, account_id: @account, id: transaction
      end

      it "should delete the transaction" do
        expect(@account.transactions.count).to eq 0
        expect(@account.transactions.last).to be_nil
      end

      it "should redirect back to the account" do
        expect(response).to redirect_to account_transactions_path(@account)
      end

      it "should set flash" do
        expect(flash[:success]).to eq "Transaction successfully deleted."
      end
    end

    context "deleting a transaction on someone else's account" do
      before do
        @account = FactoryGirl.create(:account)
        @transaction = FactoryGirl.create(:transaction, account: @account)

        delete :destroy, account_id: @account, id: @transaction
      end

      it "should not delete the transaction" do
        expect(@account.transactions.count).to eq 1
        expect(@account.transactions.last).to eq @transaction
      end

      it "should redirect back to the accounts page" do
        expect(response).to redirect_to(accounts_path)
      end

      it "should set flash" do
        expect(flash[:error]).to eq "Account could not be found."
      end
    end
  end
end

describe TransactionsController, "GET #tagged" do
  context "As a non-logged in user" do
    before do
      account = FactoryGirl.create(:account)
      tag = FactoryGirl.create(:tag)
      transaction = FactoryGirl.create(:transaction, account: account, tag: tag)

      get :tagged, account_id: account, tag_id: transaction
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

    context "accessing tagged transactions for their account" do
      before do
        @account = FactoryGirl.create(:account, user: @user)

        @tag_1 = FactoryGirl.create(:tag, user: @user)
                 FactoryGirl.create(:tag, user: @user)

        @t1 = FactoryGirl.create(:transaction, account: @account, tag: @tag_1)
              FactoryGirl.create(:transaction, account: @account)
        @t3 = FactoryGirl.create(:transaction, account: @account, tag: @tag_1)

        get :tagged, account_id: @account, tag_id: @tag_1
      end

      it "should assign the account" do
        expect(assigns(:account)).to eq @account
      end

      it "should assign the tag" do
        expect(assigns(:tag)).to eq @tag_1
      end

      it "should assign transactions with the ones tagged" do
        expect(assigns(:transactions)).to match_array([@t1, @t3])
      end
    end

    context "using someone else's tag" do
      before do
        @account = FactoryGirl.create(:account, user: @user)

        other_tag = FactoryGirl.create(:tag)

        get :tagged, account_id: @account, tag_id: other_tag
      end

      it "should redirect back to the account" do
        expect(response).to redirect_to account_transactions_path(@account)
      end

      it "should set flash" do
        expect(flash[:error]).to eq "Tag could not be found."
      end
    end

    context "accessing tagged transactions on someone else's account" do
      before do
        account = FactoryGirl.create(:account)
        tag = FactoryGirl.create(:tag)
        transaction = FactoryGirl.create(:transaction, account: account, tag: tag)

        get :tagged, account_id: account, tag_id: tag
      end

      it "should redirect back to accounts" do
        expect(response).to redirect_to accounts_path
      end

      it "should set flash" do
        expect(flash[:error]).to eq "Account could not be found."
      end
    end
  end
end
