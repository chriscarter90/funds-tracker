class TransfersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_account
  before_action :find_transfer, only: [:edit, :update, :destroy]

  def new
    @transfer = @account.transfers.build
    @transfer.build_account_transaction
  end

  def create
    @transfer = @account.transfers.build(transfer_params)
    @transfer.account_transaction.account_id = params[:account_id]

    if @transfer.save
      redirect_to account_account_transactions_path(@account), flash: { success: "Transfer successfully created." }
    else
      flash[:error] = "Transfer not created."
      render :new
    end
  end

  def edit
  end

  def update
    if @transfer.update_attributes(transfer_params)
      redirect_to account_account_transactions_path(@account), flash: { success: "Transfer successfully updated." }
    else
      flash[:error] = "Transfer not updated."
      render :edit
    end
  end

  def destroy
    @transfer.destroy

    redirect_to account_account_transactions_path(@account), flash: { success: "Transfer successfully deleted." }
  end

  protected

  def find_account
    begin
      @account = current_user.accounts.find(params[:account_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to accounts_path, flash: { error: "Account could not be found." }
    end
  end

  def find_transfer
    begin
      @transfer = @account.transfers.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to transfers_path, flash: { error: "Transfer could not be found." }
    end
  end

  def transfer_params
    params.required(:transfer).permit(:other_account_id, account_transaction_attributes: [:amount, :transaction_date, :account_id])
  end
end
