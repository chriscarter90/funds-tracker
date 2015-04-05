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

      it "should set the ending amount to the current account balance" do
        get :index, account_id: @account, page: 1

        expect(assigns(:ending_amount)).to eq 250
      end

      it "should set the starting amount for page 1" do
        get :index, account_id: @account, page: 1

        expect(assigns(:starting_amount)).to eq 150
      end

      it "should grab the last 5 transactions on page 2" do
        get :index, account_id: @account, page: 2

        expect(assigns(:transactions).size).to eq 5
        expect(assigns(:transactions).map(&:description)).to_not include("Transaction #1", "Transaction #10")
        expect(assigns(:transactions).map(&:description)).to include("Transaction #11", "Transaction #15")
      end

      it "should set the ending amount on page 2" do
        get :index, account_id: @account, page: 2

        expect(assigns(:ending_amount)).to eq 150
      end

      it "should set the starting amount to the starting account balance" do
        get :index, account_id: @account, page: 2

        expect(assigns(:starting_amount)).to eq 100
      end
    end
  end
end

describe AccountTransactionsController, "GET #tagged" do
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

      @account = FactoryGirl.create(:account, user: @user)
    end

    context "accessing tagged transactions for their account" do
      context "with less than a page" do
        before do
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

      context "with more than one page" do
        before do
          @tag = FactoryGirl.create(:tag, user: @user)
          @other_tag = FactoryGirl.create(:tag, user: @user)

          1.upto(15) do |i|
            @account.transactions << FactoryGirl.create(:transaction, description: "Transaction ##{i}", transaction_date: i.days.ago, amount: 10, tag: @tag)
          end

          1.upto(5) do |i|
            @account.transactions << FactoryGirl.create(:transaction, description: "Other Transaction ##{i}", transaction_date: i.days.ago, amount: 20, tag: @other_tag)
          end
        end

        it "should grab the first 10 transactions on page 1" do
          get :tagged, account_id: @account, tag_id: @tag, page: 1

          expect(assigns(:transactions).size).to eq 10
          expect(assigns(:transactions).map(&:description)).to include("Transaction #1", "Transaction #10")
          expect(assigns(:transactions).map(&:description)).to_not include("Transaction #11", "Transaction #15", "Other Transaction #1", "Other Transaction #5")
        end

        it "should set the ending amount on page 1" do
          get :tagged, account_id: @account, tag_id: @tag, page: 1

          expect(assigns(:ending_amount)).to eq 150
        end

        it "should set the starting amount on page 2" do
          get :tagged, account_id: @account, tag_id: @tag, page: 1

          expect(assigns(:starting_amount)).to eq 50
        end

        it "should grab the last 5 transactions on page 2" do
          get :tagged, account_id: @account, tag_id: @tag, page: 2

          expect(assigns(:transactions).size).to eq 5
          expect(assigns(:transactions).map(&:description)).to_not include("Transaction #1", "Transaction #10", "Other Transaction #1", "Other Transaction #5")
          expect(assigns(:transactions).map(&:description)).to include("Transaction #11", "Transaction #15")
        end

        it "should set the ending amount on page 2" do
          get :tagged, account_id: @account, tag_id: @tag, page: 2

          expect(assigns(:ending_amount)).to eq 50
        end

        it "should set the starting amount to zero on page 2" do
          get :tagged, account_id: @account, tag_id: @tag, page: 2

          expect(assigns(:starting_amount)).to eq 0
        end
      end
    end

    context "using someone else's tag" do
      before do
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
