# frozen_string_literal: true

class AddAmountToExpenses < ActiveRecord::Migration[5.2]
  def change
    add_monetize :expenses, :price
  end
end
