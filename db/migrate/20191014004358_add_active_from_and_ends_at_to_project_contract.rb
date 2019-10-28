# frozen_string_literal: true

class AddActiveFromAndEndsAtToProjectContract < ActiveRecord::Migration[5.2]
  def change
    add_column :project_contracts, :active_from, :date
    add_column :project_contracts, :ends_at, :date
  end
end
