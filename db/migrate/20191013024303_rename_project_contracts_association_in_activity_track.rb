class RenameProjectContractsAssociationInActivityTrack < ActiveRecord::Migration[5.2]
  def change
    rename_column :activity_tracks, :project_contracts_id, :project_contract_id
  end
end
