# frozen_string_literal: true

class AddTokenToExpenseInvitation < ActiveRecord::Migration[6.0]
  def change
    add_column :expense_invitations, :token, :string
  end
end
