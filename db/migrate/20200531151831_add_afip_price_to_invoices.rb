# frozen_string_literal: true

class AddAfipPriceToInvoices < ActiveRecord::Migration[6.0]
  def change
    add_monetize :invoices, :afip_price
  end
end
