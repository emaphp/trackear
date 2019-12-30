class AddUserAndAttachmentPropsToInvoice < ActiveRecord::Migration[5.2]
  def change
    add_reference :invoices, :user
    add_column :invoices, :invoice_data, :text
    add_column :invoices, :payment_data, :text
    add_column :invoices, :is_client_visible, :boolean
  end
end
