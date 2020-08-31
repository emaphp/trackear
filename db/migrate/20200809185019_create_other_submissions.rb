class CreateOtherSubmissions < ActiveRecord::Migration[6.0]
  def change
    create_table :other_submissions do |t|
      t.text :summary
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
