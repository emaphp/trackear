# frozen_string_literal: true

class AddProjectToProjectInvitation < ActiveRecord::Migration[6.0]
  def change
    add_reference :project_invitations, :project, null: false, foreign_key: true
  end
end
