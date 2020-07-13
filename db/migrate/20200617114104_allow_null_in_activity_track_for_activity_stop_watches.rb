class AllowNullInActivityTrackForActivityStopWatches < ActiveRecord::Migration[6.0]
  def change
    change_column_null :activity_stop_watches, :activity_track_id, true
  end
end
