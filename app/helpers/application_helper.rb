module ApplicationHelper
  def humanized_money_with_currency(amount, currency)
    humanized_money_with_symbol(Money.new(amount * 100, currency))
  end
end
