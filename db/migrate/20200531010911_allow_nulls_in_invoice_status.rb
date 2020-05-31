# frozen_string_literal: true

class AllowNullsInInvoiceStatus < ActiveRecord::Migration[6.0]
  def change
    change_column_null :invoice_statuses, :invoice_status_id, true
    change_column_null :invoice_statuses, :invoice_id, true
  end
end
