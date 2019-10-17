class RemoveUserFromInvoiceEntry < ActiveRecord::Migration[5.2]
  def change
    remove_column :invoice_entries, :user_id
  end
end
