class CreateFeedbackOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :feedback_options do |t|
      t.string :title
      t.text :summary

      t.timestamps
    end
  end
end
