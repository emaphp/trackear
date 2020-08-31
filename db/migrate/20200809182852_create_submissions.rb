class CreateSubmissions < ActiveRecord::Migration[6.0]
  def change
    create_table :submissions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :feedback_option, null: false, foreign_key: true

      t.timestamps
    end
  end
end
