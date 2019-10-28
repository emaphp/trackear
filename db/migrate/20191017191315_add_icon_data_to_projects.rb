# frozen_string_literal: true

class AddIconDataToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :icon_data, :text
  end
end
