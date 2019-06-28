class AddSalaryRangeToJobProfiles < ActiveRecord::Migration[5.2]
  def change
    remove_column :job_profiles, :salary_range
    add_column :job_profiles, :salary_min, :integer
    add_column :job_profiles, :salary_max, :integer
  end
end
