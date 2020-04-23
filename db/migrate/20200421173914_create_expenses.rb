class CreateExpenses < ActiveRecord::Migration[5.2]
  def change
    create_table :expenses do |t|
      t.string :name
      t.text :receipt_data
      t.date :from
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
