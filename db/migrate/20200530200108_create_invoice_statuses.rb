# frozen_string_literal: true

class CreateInvoiceStatuses < ActiveRecord::Migration[6.0]
  def change
    create_table :invoice_statuses do |t|
      t.references :invoice_status, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :invoice, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
