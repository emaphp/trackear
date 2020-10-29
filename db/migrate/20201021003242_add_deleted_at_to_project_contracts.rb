class AddDeletedAtToProjectContracts < ActiveRecord::Migration[6.0]
  def change
    add_column :project_contracts, :deleted_at, :datetime
    add_index :project_contracts, :deleted_at
  end
end
