class AddSpecialismToJobProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :job_profiles, :specialism, :string
  end
end
