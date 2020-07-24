class AddProjectToActivityStopWatches < ActiveRecord::Migration[6.0]
  def change
    add_reference :activity_stop_watches, :project, null: false, foreign_key: true
  end
end
