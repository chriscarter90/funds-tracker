class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_account, only: [:edit, :update, :destroy]
  before_action :find_tag, only: [:tagged]

  def index
    @accounts = current_user.accounts
    @tags = current_user.tags
  end

  def new
    @account = current_user.accounts.build
  end

  def create
    @account = current_user.accounts.build(account_params)

    if @account.save
      redirect_to accounts_path, flash: { success: "Account successfully created." }
    else
      flash[:error] = "Account not created."
      render :new
    end
  end

  def edit
  end

  def update
    if @account.update_attributes(account_params)
      redirect_to accounts_path, flash: { success: "Account successfully updated." }
    else
      flash[:error] = "Account not updated."
      render :edit
    end
  end

  def destroy
    @account.destroy

    redirect_to accounts_path, flash: { success: "Account successfully deleted." }
  end

  def tagged
    @transactions = current_user.transactions.tagged_with(@tag)
  end

  protected

  def account_params
    params.required(:account).permit(:name, :starting_balance)
  end

  def find_account
    begin
      @account = current_user.accounts.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to accounts_path, flash: { error: "Account could not be found." }
    end
  end

  def find_tag
    begin
      @tag = current_user.tags.find(params[:tag_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to accounts_path, flash: { error: "Tag could not be found." }
    end
  end
end
