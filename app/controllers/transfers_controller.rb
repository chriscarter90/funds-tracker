class TransfersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_transfer, only: [:edit, :update, :destroy]

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

  def edit
  end

  def update
    if @transfer.update_attributes(transfer_params)
      redirect_to transfers_path, flash: { success: "Transfer successfully updated." }
    else
      flash[:error] = "Transfer not updated."
      render :edit
    end
  end

  def destroy
    @transfer.destroy

    redirect_to transfers_path, flash: { success: "Transfer successfully deleted." }
  end

  protected

  def transfer_params
    params.required(:transfer).permit(:amount, :transfer_date, :to_account_id, :from_account_id)
  end

  def find_transfer
    begin
      @transfer = current_user.transfers.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to transfers_path, flash: { error: "Transfer could not be found." }
    end
  end
end
