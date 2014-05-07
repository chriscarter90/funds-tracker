class AccountsController < ApplicationController
  before_action :authenticate_user!

  def index
    @accounts = current_user.accounts
  end

  def new
    @account = current_user.accounts.build
  end

  def create
    @account = current_user.accounts.build(account_params)

    if @account.save
      redirect_to accounts_path, notice: "Account successfully created."
    else
      flash[:alert] = "Account not created."
      render :new
    end
  end

  protected

  def account_params
    params.required(:account).permit(:name)
  end
end
