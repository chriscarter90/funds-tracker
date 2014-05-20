require 'spec_helper'

describe TagsController, "GET #index" do
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

      user.tags = FactoryGirl.create_list(:tag, 6)

      get :index
    end

    it "assigns their tags" do
      expect(assigns(:tags).size).to eq 6
    end
  end
end

describe TagsController, "GET #new" do
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

    it "assigns a new tag" do
      expect(assigns(:tag)).to be_a_new Tag
    end

    it "renders the new template" do
      expect(response).to render_template :new
    end
  end
end

describe TagsController, "POST #create" do
  context "As a non-logged in user" do
    before do
      tag_attrs = FactoryGirl.attributes_for(:tag)

      post :create, tag: tag_attrs
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
        valid_params = FactoryGirl.attributes_for(:tag, name: "An Example Tag")

        post :create, tag: valid_params
      end

      it "creates a new tag for the user" do
        expect(@user.tags.count).to eq 1
        expect(@user.tags.last.name).to eq "An Example Tag"
      end

      it "should redirect to index" do
        expect(response).to redirect_to tags_path
      end

      it "should set flash" do
        expect(flash[:success]).to eq "Tag successfully created."
      end
    end

    context "with invalid params" do
      before do
        invalid_params = FactoryGirl.attributes_for(:tag, name: "")

        post :create, tag: invalid_params
      end

      it "doesn't create an tag" do
        expect(@user.tags.count).to eq 0
      end

      it "should render new" do
        expect(response).to render_template :new
      end

      it "should set flash" do
        expect(flash[:error]).to eq "Tag not created."
      end
    end
  end
end
