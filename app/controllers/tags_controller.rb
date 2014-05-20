class TagsController < ApplicationController
  before_action :authenticate_user!

  def index
    @tags = current_user.tags
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

  protected

  def tag_params
    params.required(:tag).permit(:name)
  end
end
