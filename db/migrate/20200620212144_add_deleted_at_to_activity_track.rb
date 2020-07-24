class AddDeletedAtToActivityTrack < ActiveRecord::Migration[6.0]
  def change
    add_column :activity_tracks, :deleted_at, :datetime
    add_index :activity_tracks, :deleted_at
  end
end
