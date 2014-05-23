class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_account
  before_action :find_transaction, only: [:edit, :update, :destroy]
  before_action :find_tag, only: [:tagged]

  def new
    @transaction = @account.transactions.build
  end

  def create
    @transaction = @account.transactions.build(transaction_params)

    if @transaction.save
      redirect_to account_path(@account), flash: { success: "Transaction successfully created." }
    else
      flash[:error] = "Transaction not created."
      render :new
    end
  end

  def edit
  end

  def update
    if @transaction.update_attributes(transaction_params)
      redirect_to account_path(@account), flash: { success: "Transaction successfully updated." }
    else
      flash[:error] = "Transaction not updated."
      render :edit
    end
  end

  def destroy
    @transaction.destroy

    redirect_to account_path(@account), flash: { success: "Transaction successfully deleted." }
  end

  def tagged
    @tag = current_user.tags.find(params[:tag_id])
    @transactions = @account.transactions.tagged_with(@tag)
  end

  protected

  def find_account
    begin
      @account = current_user.accounts.find(params[:account_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to accounts_path, flash: { error: "Account could not be found." }
    end
  end

  def find_transaction
    @transaction = @account.transactions.find(params[:id])
  end

  def find_tag
    begin
      @tag = current_user.tags.find(params[:tag_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to account_path(@account), flash: { error: "Tag could not be found." }
    end
  end

  def transaction_params
    params.required(:transaction).permit(:description, :amount, :transaction_date, :tag_id)
  end
end
