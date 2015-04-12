class AccountTransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_account

  def index
    params[:page] ||= 1
    per_page = 10

    @account_transactions = @account.account_transactions.newest_first.page(params[:page]).per(per_page)

    if @account_transactions.any?
      @starting_amount = @account.balance_up_to(@account_transactions.last)
      # The following line does NOT work if you use `sum(:amount)` instead of `pluck(:amount).sum`
      # If you use sum(:amount), then it LIMIT/OFFSETs AFTER doing the sum so returns no rows :(
      @ending_amount = @starting_amount + @account_transactions.pluck(:amount).sum
    end
  end
  protected

  def find_account
    begin
      @account = current_user.accounts.find(params[:account_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to accounts_path, flash: { error: "Account could not be found." }
    end
  end
end
