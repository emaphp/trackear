# frozen_string_literal: true

class AddIsVisibleToInvoice < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :is_visible, :boolean
  end
end
