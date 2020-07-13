# frozen_string_literal: true

class CreateProject < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :currency
    end
  end
end
