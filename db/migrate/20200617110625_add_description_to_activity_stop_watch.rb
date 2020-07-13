class AddDescriptionToActivityStopWatch < ActiveRecord::Migration[6.0]
  def change
    add_column :activity_stop_watches, :description, :string
  end
end
