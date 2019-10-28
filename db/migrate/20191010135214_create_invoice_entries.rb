# frozen_string_literal: true

class CreateInvoiceEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :invoice_entries do |t|
      t.string :description
      t.decimal :rate
      t.references :project, foreign_key: true
      t.references :invoice, foreign_key: true
      t.datetime :from
      t.datetime :to
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
