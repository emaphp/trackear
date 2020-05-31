# frozen_string_literal: true

class AddLastCheckedToInvoiceStatus < ActiveRecord::Migration[6.0]
  def change
    add_column :invoice_statuses, :last_checked, :datetime
  end
end
