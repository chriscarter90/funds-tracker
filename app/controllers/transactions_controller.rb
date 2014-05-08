class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_account

  def new
    @transaction = @account.transactions.build
  end

  def create
    @transaction = @account.transactions.build(transaction_params)

    if @transaction.save
      redirect_to account_path(@account), notice: "Transaction successfully created."
    else
      flash[:alert] = "Transaction not created."
      render :new
    end
  end

  protected

  def find_account
    begin
      @account = current_user.accounts.find(params[:account_id])
    rescue ActiveRecord::RecordNotFound => e
      redirect_to accounts_path, alert: "Account could not be found."
    end
  end

  def transaction_params
    params.required(:transaction).permit(:description, :amount)
  end
end
