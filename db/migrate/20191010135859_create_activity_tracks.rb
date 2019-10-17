class CreateActivityTracks < ActiveRecord::Migration[5.2]
  def change
    create_table :activity_tracks do |t|
      t.string :description
      t.references :project, foreign_key: true
      t.datetime :from
      t.datetime :to
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
