# frozen_string_literal: true

module ExpensesHelper
  def calculate_total(expenses)
    expenses.collect(&:price).sum
  end
end
