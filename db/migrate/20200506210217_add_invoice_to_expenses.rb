# frozen_string_literal: true

class AddInvoiceToExpenses < ActiveRecord::Migration[6.0]
  def change
    add_column :expenses, :invoice_data, :string
  end
end
