class CreateExpenseInvitations < ActiveRecord::Migration[6.0]
  def change
    create_table :expense_invitations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :email
      t.string :name
      t.string :status

      t.timestamps
    end
  end
end
