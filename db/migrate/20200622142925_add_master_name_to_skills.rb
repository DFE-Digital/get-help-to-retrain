class AddMasterNameToSkills < ActiveRecord::Migration[6.0]
  def change
    add_column :skills, :master_name, :string
  end
end
