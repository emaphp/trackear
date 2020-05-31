# frozen_string_literal: true

class AddExchangeToInvoices < ActiveRecord::Migration[6.0]
  def change
    add_monetize :invoices, :exchange
  end
end
