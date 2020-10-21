class CreateProjectInvitations < ActiveRecord::Migration[6.0]
  def change
    drop_table(:project_invitations, if_exists: true)
    create_table :project_invitations do |t|
      t.string :email
      t.string :token
      t.references :user, null: false, foreign_key: true
      t.string :activity
      t.references :project, null: false, foreign_key: true
      t.decimal :project_rate
      t.decimal :user_rate
      t.string :status

      t.timestamps
    end
  end
end
