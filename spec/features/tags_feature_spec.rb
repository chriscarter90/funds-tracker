require 'spec_helper'

feature "Tags", %q{

} do

  context "As a non-logged in user" do
    scenario "Trying to view the list of tags" do
      visit tags_path

      expect(current_path).to eq new_user_session_path

      expect(page).to have_content("You need to sign in or sign up before continuing.")
    end

    scenario "Trying to create a new tag" do
      visit new_tag_path

      expect(current_path).to eq new_user_session_path

      expect(page).to have_content("You need to sign in or sign up before continuing.")
    end
  end

  context "As a logged in user" do
    before do
      @user = FactoryGirl.create(:user)
      sign_in_as @user
    end

    scenario "Viewing an empty list of tags" do
      visit tags_path

      expect(page).to have_content("Tags")

      expect(page).to have_content("You have no tags. Try making one here.")
      expect(page).to have_link("here", href: new_tag_path)
    end

    scenario "Viewing your tags" do
      @user.tags << FactoryGirl.create(:tag, name: "Food")
      @user.tags << FactoryGirl.create(:tag, name: "Accommodation")

      visit tags_path

      expect(page).to have_content("Tags")

      expect(page).to have_table_columns(["Name", "Actions"])

      expect(page).to have_table_rows_in_order(
        ["Accommodation", "Edit Delete"],
        ["Food", "Edit Delete"]
      )
    end

    scenario "Creating a new tag" do
      visit tags_path

      expect(page).to have_link("New Tag")

      click_link "New Tag"

      expect(page).to have_content("New Tag")

      expect(page).to have_field("Name")
      click_button "Create Tag"

      expect(page).to have_content("Tag not created.")
      within ".tag_name" do
        expect(page).to have_content("can't be blank")
      end

      fill_in "Name", with: "Example Tag"

      click_button "Create Tag"

      expect(current_path).to eq tags_path
      expect(page).to have_content("Tag successfully created.")

      expect(page).to have_table_rows_in_order(
        ["Example Tag", "Edit Delete"]
      )
    end
  end
end
