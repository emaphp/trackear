# frozen_string_literal: true

class UpdateActivityTrackAssociation < ActiveRecord::Migration[5.2]
  def change
    remove_column :activity_tracks, :project_id
    remove_column :activity_tracks, :user_id
    add_reference :activity_tracks, :project_contracts
  end
end
