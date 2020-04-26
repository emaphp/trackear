# frozen_string_literal: true

class AddUniqueEmailUserExpenseInvitationIndexToExpenseInvitations < ActiveRecord::Migration[6.0]
  def change
    add_index :expense_invitations, %i[email user_id], unique: true
  end
end
