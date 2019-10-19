class AddIsPremiumToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_premium, :boolean
  end
end
