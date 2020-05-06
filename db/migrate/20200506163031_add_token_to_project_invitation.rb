# frozen_string_literal: true

class AddTokenToProjectInvitation < ActiveRecord::Migration[6.0]
  def change
    add_column :project_invitations, :token, :string
  end
end
