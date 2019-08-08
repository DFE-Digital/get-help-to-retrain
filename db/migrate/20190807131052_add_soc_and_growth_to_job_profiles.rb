class AddSocAndGrowthToJobProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :job_profiles, :soc, :string
    add_column :job_profiles, :extended_soc, :string
    add_column :job_profiles, :growth, :decimal
  end
end
