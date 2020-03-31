class AddSectorAndHierarchyToJobProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :job_profiles, :sector, :string
    add_column :job_profiles, :hierarchy, :string
  end
end
