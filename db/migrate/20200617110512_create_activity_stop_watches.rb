class CreateActivityStopWatches < ActiveRecord::Migration[6.0]
  def change
    create_table :activity_stop_watches do |t|
      t.datetime :start
      t.datetime :end
      t.boolean :paused
      t.references :activity_track, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
