# frozen_string_literal: true

class AddUserFixedRateToProjectContracts < ActiveRecord::Migration[6.0]
  def change
    add_column :project_contracts, :user_fixed_rate, :decimal
  end
end
