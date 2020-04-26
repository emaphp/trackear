# frozen_string_literal: true

class AddDeletedAtToInvoice < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :deleted_at, :datetime
    add_index :invoices, :deleted_at
  end
end
