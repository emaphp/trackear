# frozen_string_literal: true

class AddFromAndToToInvoice < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :from, :date
    add_column :invoices, :to, :date
  end
end
