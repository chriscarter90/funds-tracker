module TransactionsHelper
  def transaction_amount(t)
    number_to_currency(t.amount)
  end
end
