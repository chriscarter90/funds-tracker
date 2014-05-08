class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_account, only: [:show, :edit, :update, :destroy]

  def index
    @accounts = current_user.accounts
  end

  def show
    @transactions = @account.transactions
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

  protected

  def account_params
    params.required(:account).permit(:name)
  end

  def find_account
    begin
      @account = current_user.accounts.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      redirect_to accounts_path, flash: { error: "Account could not be found." }
    end
  end
end
