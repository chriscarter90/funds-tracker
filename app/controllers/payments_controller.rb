class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_account
  before_action :find_payment, only: [:edit, :update, :destroy]

  def new
    @payment = @account.payments.build
    @payment.build_account_transaction
  end

  def create
    @payment = @account.payments.build(payment_params)
    @payment.account_transaction.account_id = params[:account_id]

    if @payment.save
      redirect_to account_account_transactions_path(@account), flash: { success: "Payment successfully created." }
    else
      flash[:error] = "Payment not created."
      render :new
    end
  end

  def edit
  end

  def update
    if @payment.update_attributes(payment_params)
      redirect_to account_account_transactions_path(@account), flash: { success: "Payment successfully updated." }
    else
      flash[:error] = "Payment not updated."
      render :edit
    end
  end

  def destroy
    @payment.destroy

    redirect_to account_account_transactions_path(@account), flash: { success: "Payment successfully deleted." }
  end

  protected

  def find_account
    begin
      @account = current_user.accounts.find(params[:account_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to accounts_path, flash: { error: "Account could not be found." }
    end
  end

  def find_payment
    begin
      @payment = @account.payments.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to account_account_transactions_path(@account), flash: { error: "Payment could not be found." }
    end
  end

  def payment_params
    params.required(:payment).permit(:description, account_transaction_attributes: [:amount, :transaction_date, :account_id])
  end
end
