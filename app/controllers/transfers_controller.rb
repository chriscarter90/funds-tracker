class TransfersController < ApplicationController
  before_action :authenticate_user!

  def index
    @transfers = current_user.transfers.newest_first
  end

  def new
    @transfer = current_user.transfers.build
  end

  def create
    @transfer = current_user.transfers.build(transfer_params)

    if @transfer.save
      redirect_to transfers_path, flash: { success: "Transfer successfully created." }
    else
      flash[:error] = "Transfer not created."
      render :new
    end
  end

  protected

  def transfer_params
    params.required(:transfer).permit(:amount, :transfer_date, :to_account_id, :from_account_id)
  end
end
