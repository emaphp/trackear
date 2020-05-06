# frozen_string_literal: true

class CreateProjectInvitations < ActiveRecord::Migration[6.0]
  def change
    create_table :project_invitations do |t|
      t.string :email
      t.references :user, null: false, foreign_key: true
      t.string :activity
      t.string :status

      t.timestamps
    end
  end
end
