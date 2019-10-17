class CreateProjectContracts < ActiveRecord::Migration[5.2]
  def change
    create_table :project_contracts do |t|
      t.references :project, foreign_key: true
      t.references :user, foreign_key: true
      t.string :activity
      t.decimal :project_rate
      t.decimal :user_rate

      t.timestamps
    end
  end
end
