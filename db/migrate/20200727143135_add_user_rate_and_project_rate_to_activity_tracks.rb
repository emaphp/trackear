class AddUserRateAndProjectRateToActivityTracks < ActiveRecord::Migration[6.0]
  def change
    add_column :activity_tracks, :user_rate, :decimal
    add_column :activity_tracks, :project_rate, :decimal
  end
end
