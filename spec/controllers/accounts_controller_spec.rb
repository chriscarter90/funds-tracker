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

      user.accounts = FactoryGirl.create_list(:account, 3, user: user)
      user.tags = FactoryGirl.create_list(:tag, 4, user: user)

      get :index
    end

    it "assigns their accounts" do
      expect(assigns(:accounts).size).to eq 3
    end

    it "assigns their tags" do
      expect(assigns(:tags).size).to eq 4
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
        expect(flash[:success]).to eq "Account successfully created."
      end
    end

    context "with invalid params" do
      before do
        invalid_params = FactoryGirl.attributes_for(:account, name: "")

        post :create, account: invalid_params
      end

      it "doesn't create an account" do
        expect(@user.accounts.count).to eq 0
      end

      it "should render new" do
        expect(response).to render_template :new
      end

      it "should set flash" do
        expect(flash[:error]).to eq "Account not created."
      end
    end
  end
end

describe AccountsController, "GET #edit" do
  context "As a non-logged in user" do
    before do
      account = FactoryGirl.create(:account)

      get :edit, id: account
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

    context "with an account" do
      before do
        @account = FactoryGirl.create(:account, user: @user)

        get :edit, id: @account
      end

      it "should assign the account" do
        expect(assigns(:account)).to eq @account
      end

      it "should render the edit template" do
        expect(response).to render_template :edit
      end
    end

    context "accessing an account which isn't theirs" do
      before do
        account = FactoryGirl.create(:account)

        get :edit, id: account
      end

      it "redirects to the index" do
        expect(response).to redirect_to accounts_path
      end

      it "sets flash" do
        expect(flash[:error]).to eq "Account could not be found."
      end
    end
  end
end

describe AccountsController, "PATCH #update" do
  context "As a non-logged in user" do
    before do
      account = FactoryGirl.create(:account)

      patch :update, id: account, account: { name: "New Account Name" }
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

    context "updating an account which is theirs" do
      before do
        @account = FactoryGirl.create(:account, name: "An Account", user: @user)
      end

      context "with valid params" do
        before do
          patch :update, id: @account, account: { name: "New Account Name" }
        end

        it "updates the account" do
          expect(@account.reload.name).to eq "New Account Name"
        end

        it "should redirect to index" do
          expect(response).to redirect_to accounts_path
        end

        it "should set flash" do
          expect(flash[:success]).to eq "Account successfully updated."
        end
      end

      context "with invalid params" do
        before do
          patch :update, id: @account, account: { name: "" }
        end

        it "doesn't update account" do
          expect(@account.reload.name).to eq "An Account"
        end

        it "should render edit" do
          expect(response).to render_template :edit
        end

        it "should set flash" do
          expect(flash[:error]).to eq "Account not updated."
        end
      end
    end

    context "updating someone elses account" do
      before do
        @account = FactoryGirl.create(:account, name: "Another Account")

        patch :update, id: @account, account: { name: "New Account Name" }
      end

      it "doesn't update account" do
        expect(@account.reload.name).to eq "Another Account"
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

describe AccountsController, "GET #tagged" do
  context "As a non-logged in user" do
    before do
      tag = FactoryGirl.create(:tag)

      get :tagged, tag_id: tag
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
        account_1 = FactoryGirl.create(:account, user: @user)
        account_2 = FactoryGirl.create(:account, user: @user)

        @tag_1 = FactoryGirl.create(:tag, user: @user)

        @t1 = FactoryGirl.create(:transaction, account: account_1, tag: @tag_1)
              FactoryGirl.create(:transaction, account: account_1)
        @t3 = FactoryGirl.create(:transaction, account: account_2, tag: @tag_1)
        @t4 = FactoryGirl.create(:transaction, account: account_1, tag: @tag_1)

        get :tagged, tag_id: @tag_1
      end

      it "should assign the tag" do
        expect(assigns(:tag)).to eq @tag_1
      end

      it "should assign transactions with the ones tagged" do
        expect(assigns(:transactions)).to match_array([@t1, @t3, @t4])
      end
    end

    context "using someone else's tag" do
      before do
        other_tag = FactoryGirl.create(:tag)

        get :tagged, tag_id: other_tag
      end

      it "should redirect back to accounts" do
        expect(response).to redirect_to accounts_path
      end

      it "should set flash" do
        expect(flash[:error]).to eq "Tag could not be found."
      end
    end
  end
end
