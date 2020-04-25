module ExpensesHelper
    def calculate_total(expenses)
        expenses.collect(&:price_unit).sum
    end
end
