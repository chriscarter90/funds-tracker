class AccountTransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_account
  before_action :find_account_transaction, only: [:edit, :update, :destroy]
  before_action :find_tag, only: [:tagged]

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

    @tags = current_user.tags
  end

  def tagged
    params[:page] ||= 1
    per_page = 10

    @account_transactions = @account.account_transactions.tagged_with(@tag).newest_first.page(params[:page]).per(per_page)

    if @account_transactions.any?
      @starting_amount = @account.account_transactions.tagged_with(@tag).newest_first.before(@account_transactions.last).sum(:amount)
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

  def find_tag
    begin
      @tag = current_user.tags.find(params[:tag_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to account_transactions_path(@account), flash: { error: "Tag could not be found." }
    end
  end
end
