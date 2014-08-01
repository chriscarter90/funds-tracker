class TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_tag, only: [:edit, :update, :destroy]

  def index
    @tags = current_user.tags.by_name
  end

  def new
    @tag = current_user.tags.build
  end

  def create
    @tag = current_user.tags.build(tag_params)

    if @tag.save
      redirect_to tags_path, flash: { success: "Tag successfully created." }
    else
      flash[:error] = "Tag not created."
      render :new
    end
  end

  def edit
  end

  def update
    if @tag.update_attributes(tag_params)
      redirect_to tags_path, flash: { success: "Tag successfully updated." }
    else
      flash[:error] = "Tag not updated."
      render :edit
    end
  end

  def destroy
    @tag.destroy

    redirect_to tags_path, flash: { success: "Tag successfully deleted." }
  end

  protected

  def tag_params
    params.required(:tag).permit(:name)
  end

  def find_tag
    begin
      @tag = current_user.tags.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to tags_path, flash: { error: "Tag could not be found." }
    end
  end
end
