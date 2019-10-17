class AddActivityTrackToInvoiceEntry < ActiveRecord::Migration[5.2]
  def change
    add_reference :invoice_entries, :activity_track
  end
end
