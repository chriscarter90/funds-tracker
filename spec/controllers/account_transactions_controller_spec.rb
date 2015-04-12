require 'rails_helper'

describe AccountTransactionsController, "GET #index" do
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
        @account.account_transactions << [FactoryGirl.create(:account_transaction, amount: 12, transaction_date: 5.days.ago),
                                          FactoryGirl.create(:account_transaction, amount: 45, transaction_date: 5.weeks.ago),
                                          FactoryGirl.create(:account_transaction, amount: 78, transaction_date: 3.days.ago)]

        get :index, account_id: @account
      end

      it "assigns the account" do
        expect(assigns(:account)).to eq @account
      end

      it "assigns the transactions" do
        expect(assigns(:account_transactions).size).to eq 3
        expect(assigns(:account_transactions).pluck(:amount)).to eq [78, 12, 45]
      end

      it "renders index" do
        expect(response).to render_template :index
      end
    end

    context "with more than a page" do
      before do
        @account.update_attributes(starting_balance: 100)

        1.upto(15) do |i|
          @account.account_transactions << FactoryGirl.create(:account_transaction, transaction_date: i.days.ago, amount: i*100)
        end
      end

      it "should grab the first 10 transactions on page 1" do
        get :index, account_id: @account, page: 1

        expect(assigns(:account_transactions).size).to eq 10
        expect(assigns(:account_transactions).pluck(:amount)).to include(100, 1_000)
        expect(assigns(:account_transactions).pluck(:amount)).to_not include(1_100, 1_500)
      end

      it "should set the ending amount to the current account balance" do
        get :index, account_id: @account, page: 1

        expect(assigns(:ending_amount)).to eq 12_100
      end

      it "should set the starting amount for page 1" do
        get :index, account_id: @account, page: 1

        expect(assigns(:starting_amount)).to eq 6_600
      end

      it "should grab the last 5 transactions on page 2" do
        get :index, account_id: @account, page: 2

        expect(assigns(:account_transactions).size).to eq 5
        expect(assigns(:account_transactions).pluck(:amount)).to_not include(100, 1_000)
        expect(assigns(:account_transactions).pluck(:amount)).to include(1_100, 1_500)
      end

      it "should set the ending amount on page 2" do
        get :index, account_id: @account, page: 2

        expect(assigns(:ending_amount)).to eq 6_600
      end

      it "should set the starting amount to the starting account balance" do
        get :index, account_id: @account, page: 2

        expect(assigns(:starting_amount)).to eq 100
      end
    end
  end
end
