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

describe TransfersController, "GET #new" do
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

    it "assigns a new transfer" do
      expect(assigns(:transfer)).to be_a_new Transfer
    end

    it "renders the new template" do
      expect(response).to render_template :new
    end
  end
end

describe TransfersController, "POST #create" do
  context "As a non-logged in user" do
    before do
      transfer_attrs = FactoryGirl.attributes_for(:transfer)

      post :create, transfer: transfer_attrs
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
        @to_account = FactoryGirl.create(:account, user: @user)
        @from_account = FactoryGirl.create(:account, user: @user)

        valid_params = FactoryGirl.attributes_for(:transfer, transfer_date: "01-03-2015").merge(
                                                    to_account_id: @to_account.id,
                                                    from_account_id: @from_account.id
                                                 )

        post :create, transfer: valid_params
      end

      it "creates a new transfer for the user" do
        expect(@user.transfers.count).to eq 1
        expect(@user.transfers.last.transfer_date).to eq Date.parse("01-03-2015")
      end

      it "should redirect to index" do
        expect(response).to redirect_to transfers_path
      end

      it "should set flash" do
        expect(flash[:success]).to eq "Transfer successfully created."
      end
    end

    context "with invalid params" do
      before do
        invalid_params = FactoryGirl.attributes_for(:transfer, transfer_date: nil)

        post :create, transfer: invalid_params
      end

      it "doesn't create an transfer" do
        expect(@user.transfers.count).to eq 0
      end

      it "should render new" do
        expect(response).to render_template :new
      end

      it "should set flash" do
        expect(flash[:error]).to eq "Transfer not created."
      end
    end
  end
end

describe TransfersController, "GET #edit" do
  context "As a non-logged in user" do
    before do
      transfer = FactoryGirl.create(:transfer)

      get :edit, id: transfer
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

    context "with an transfer" do
      before do
        @transfer = FactoryGirl.create(:transfer, transfer_date: "01-03-2015",
                                       to_account:   FactoryGirl.create(:account, user: @user),
                                       from_account: FactoryGirl.create(:account, user: @user))

        get :edit, id: @transfer
      end

      it "should assign the transfer" do
        expect(assigns(:transfer)).to eq @transfer
      end

      it "should render the edit template" do
        expect(response).to render_template :edit
      end
    end

    context "accessing a transfer which isn't theirs" do
      before do
        transfer = FactoryGirl.create(:transfer)

        get :edit, id: transfer
      end

      it "redirects to the index" do
        expect(response).to redirect_to transfers_path
      end

      it "sets flash" do
        expect(flash[:error]).to eq "Transfer could not be found."
      end
    end
  end
end

describe TransfersController, "PATCH #update" do
  context "As a non-logged in user" do
    before do
      transfer = FactoryGirl.create(:transfer)

      patch :update, id: transfer, transfer: { transfer_date: "01-03-2015" }
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

    context "updating an transfer which is theirs" do
      before do
        @transfer = FactoryGirl.create(:transfer, transfer_date: "01-03-2015",
                                       to_account:   FactoryGirl.create(:account, user: @user),
                                       from_account: FactoryGirl.create(:account, user: @user))
      end

      context "with valid params" do
        before do
          patch :update, id: @transfer, transfer: { transfer_date: "31-01-2015" }
        end

        it "updates the transfer" do
          expect(@transfer.reload.transfer_date).to eq Date.parse("31-01-2015")
        end

        it "should redirect to index" do
          expect(response).to redirect_to transfers_path
        end

        it "should set flash" do
          expect(flash[:success]).to eq "Transfer successfully updated."
        end
      end

      context "with invalid params" do
        before do
          patch :update, id: @transfer, transfer: { transfer_date: nil }
        end

        it "doesn't update transfer" do
          expect(@transfer.reload.transfer_date).to eq Date.parse("01-03-2015")
        end

        it "should render edit" do
          expect(response).to render_template :edit
        end

        it "should set flash" do
          expect(flash[:error]).to eq "Transfer not updated."
        end
      end
    end

    context "updating someone elses transfer" do
      before do
        @transfer = FactoryGirl.create(:transfer, transfer_date: "03-01-2015")

        patch :update, id: @transfer, transfer: { transfer_date: "14-02-2015" }
      end

      it "doesn't update transfer" do
        expect(@transfer.reload.transfer_date).to eq Date.parse("03-01-2015")
      end

      it "should redirect to index" do
        expect(response).to redirect_to transfers_path
      end

      it "should set flash" do
        expect(flash[:error]).to eq "Transfer could not be found."
      end
    end
  end
end

describe TransfersController, "DELETE #destroy" do
  context "As a non-logged in user" do
    before do
      transfer = FactoryGirl.create(:transfer)

      delete :destroy, id: transfer
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

    context "deleting a transfer on their account" do
      before do
        @transfer = FactoryGirl.create(:transfer, transfer_date: "01-03-2015",
                                       to_account:   FactoryGirl.create(:account, user: @user),
                                       from_account: FactoryGirl.create(:account, user: @user))

        delete :destroy, id: @transfer
      end

      it "deletes the transfer" do
        expect(@user.transfers.count).to eq 0
        expect(@user.transfers.last).to be_nil
      end

      it "redirects back to transfers" do
        expect(response).to redirect_to transfers_path
      end

      it "sets flash" do
        expect(flash[:success]).to eq "Transfer successfully deleted."
      end
    end

    context "deleting a transfer on someone else's account" do
      before do
        @transfer = FactoryGirl.create(:transfer)

        delete :destroy, id: @transfer
      end

      it "should not delete the transfer" do
        expect(Transfer.count).to eq 1
        expect(Transfer.last).to eq @transfer
      end

      it "should redirect back to the transfers page" do
        expect(response).to redirect_to(transfers_path)
      end

      it "should set flash" do
        expect(flash[:error]).to eq "Transfer could not be found."
      end
    end
  end
end
