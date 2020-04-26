class AddUniqueEmailUserExpenseInvitationIndexToExpenseInvitations < ActiveRecord::Migration[6.0]
  def change
    add_index :expense_invitations, [:email, :user_id], unique: true
  end
end
