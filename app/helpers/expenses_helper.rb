module ExpensesHelper
    def calculate_total(expenses)
        expenses.collect(&:price).sum
    end
end
