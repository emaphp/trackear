class AddClientInfoToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :client_full_name, :string
    add_column :projects, :client_address, :string
    add_column :projects, :client_email, :string
  end
end
