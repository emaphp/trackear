# frozen_string_literal: true

class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.references :project, foreign_key: true
      t.decimal :discount_percentage
      t.string :currency

      t.timestamps
    end
  end
end
