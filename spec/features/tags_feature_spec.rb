require 'rails_helper'

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

    scenario "Trying to edit an existing tag" do
      tag = FactoryGirl.create(:tag)

      visit edit_tag_path(tag)

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

    context "editing an tag" do
      scenario "as the user whose tag it is" do
        FactoryGirl.create(:tag, name: "Original Tag", user: @user)

        visit tags_path

        expect(page).to have_table_rows_in_order(
          ["Original Tag", "Edit Delete"]
        )

        expect(page).to have_link("Edit")
        click_link("Edit")

        expect(page).to have_content("Edit Tag")
        expect(page).to have_field("Name", with: "Original Tag")
        fill_in "Name", with: ""
        click_button "Update Tag"

        expect(page).to have_content("Tag not updated.")
        within ".tag_name" do
          expect(page).to have_content("can't be blank")
        end

        fill_in "Name", with: "Edited Tag"
        click_button "Update Tag"

        expect(current_path).to eq tags_path
        expect(page).to have_content("Tag successfully updated.")

        expect(page).to have_table_rows_in_order(
          ["Edited Tag", "Edit Delete"]
        )
      end

      scenario "as a different user" do
        tag = FactoryGirl.create(:tag, name: "Not My Tag")

        visit tags_path

        expect(page).to_not have_content("Not My Tag")

        visit edit_tag_path(tag)

        expect(current_path).to eq tags_path

        expect(page).to have_content("Tag could not be found.")
      end
    end

    scenario "deleting an tag" do
      FactoryGirl.create(:tag, name: "Old Tag", user: @user)

      visit tags_path

      expect(page).to have_link("Delete")

      click_link "Delete"

      expect(current_path).to eq tags_path

      expect(page).to_not have_content("Old Tag")

      expect(page).to have_content("Tag successfully deleted.")
    end
  end
end
