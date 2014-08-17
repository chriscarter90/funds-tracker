class TransfersController < ApplicationController
  before_action :authenticate_user!

  def index
    @transfers = current_user.transfers.newest_first
  end
end
