class AddEnabledToSkills < ActiveRecord::Migration[5.2]
  def change
    add_column :skills, :enabled, :boolean, default: true, null: false
    add_index :skills, :enabled
  end
end
