class AddInvoiceToReport < ActiveRecord::Migration[5.2]
  def change
    add_reference :reports, :invoice
  end
end
