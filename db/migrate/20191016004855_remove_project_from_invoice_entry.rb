# frozen_string_literal: true

class RemoveProjectFromInvoiceEntry < ActiveRecord::Migration[5.2]
  def change
    remove_column :invoice_entries, :project_id
  end
end
